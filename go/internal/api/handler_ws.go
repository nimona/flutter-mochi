package api

import (
	"bytes"
	"encoding/json"
	"image/png"
	"io"
	"net/http"
	"sync"

	"mochi.io/internal/store"

	"github.com/gorilla/websocket"
	"github.com/tsdtsdtsd/identicon"

	"nimona.io/pkg/context"
	"nimona.io/pkg/http/router"
	"nimona.io/pkg/log"
	"nimona.io/pkg/object"
)

type (
	// ContactAddRequest -
	ContactAddRequest struct {
		Alias       string `json:"alias"`
		IdentityKey string `json:"identityKey"`
	}
	// ContactUpdateRequest -
	ContactUpdateRequest struct {
		Alias       string `json:"alias"`
		IdentityKey string `json:"identityKey"`
	}
	// ContactsGetRequest -
	ContactsGetRequest struct {
	}
	// OwnProfileUpdateRequest -
	OwnProfileUpdateRequest struct {
		NameFirst string `json:"nameFirst"`
		NameLast  string `json:"nameLast"`
	}
	// OwnProfileGetRequest -
	OwnProfileGetRequest struct {
	}
	// ConversationInviteIdentityRequest -
	ConversationInviteIdentityRequest struct {
		Conversation      string `json:"hash"`
		IdentityPublicKey string `json:"key"`
	}
	// ConversationStartRequest -
	ConversationStartRequest struct {
		Name  string `json:"name"`
		Topic string `json:"topic"`
	}
	// ConversationJoinRequest -
	ConversationJoinRequest struct {
		ConversationHash string `json:"hash"`
	}
	// ConversationsGetRequest -
	ConversationsGetRequest struct {
	}
	// MessageCreateRequest -
	MessageCreateRequest struct {
		Conversation string `json:"conversationHash"`
		Body         string `json:"body"`
	}
	// MessagesGetRequest -
	MessagesGetRequest struct {
		Conversation string `json:"conversationHash"`
	}
	// // RegisterRequest -
	// RegisterRequest struct {
	// 	Seed string `json:"privateKeySeed"`
	// }
	// // ContactRequest -
	// ContactRequest struct {
	// 	Alias             string `json:"alias"`
	// 	IdentityPublicKey string `json:"identityPublicKey"`
	// }
)

type wsConn struct {
	conn *websocket.Conn
	lock *sync.Mutex
}

// HandleWS -
func (api *API) HandleWS(c *router.Context) {
	wsupgrader := websocket.Upgrader{
		ReadBufferSize:  1024,
		WriteBufferSize: 1024,
		CheckOrigin: func(r *http.Request) bool {
			return true
		},
	}

	httpConn, err := wsupgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		c.AbortWithError(500, err) // nolint: errcheck
		return
	}

	conn := &wsConn{
		conn: httpConn,
		lock: &sync.Mutex{},
	}

	// api.conversationStart(conn, ConversationStartRequest{
	// 	Name:  "#random",
	// 	Topic: "Hello world!",
	// })

	// api.createProfile(conn, CreateProfileRequest{
	// 	DisplayPicture: getIdenticon(api.local.GetIdentityPublicKey().String()),
	// 	NameFirst:      "George",
	// 	NameLast:       "Antoniadis",
	// })

	ctx := context.Background()
	logger := log.FromContext(ctx).Named("api")

	for {
		_, msg, err := httpConn.ReadMessage()
		if err != nil {
			if err == io.EOF {
				logger.Debug("ws conn is dead", log.Error(err))
				return
			}

			if websocket.IsCloseError(err, websocket.CloseGoingAway, websocket.CloseNormalClosure) {
				logger.Debug("ws conn closed", log.Error(err))
				return
			}

			if websocket.IsUnexpectedCloseError(err) {
				logger.Warn("ws conn closed with unexpected error", log.Error(err))
				return
			}

			logger.Warn("could not read from ws", log.Error(err))
			continue
		}

		m := map[string]interface{}{}
		if err := json.Unmarshal(msg, &m); err != nil {
			logger.Error("could not unmarshal outgoing object", log.Error(err))
			continue
		}

		// fmt.Println("Got", string(msg))

		switch m["_action"] {
		case "contactsGet":
			api.store.HandleProfiles(func(p store.Contact) {
				// fmt.Println("Handling contact", p)
				write(conn, p)
			})
			ps, _ := api.store.GetContacts()
			for _, p := range ps {
				// fmt.Println("Handling old contact", p)
				if err := write(conn, p); err != nil {
					panic(err)
				}
			}

		case "ownProfileUpdate":
			r := OwnProfileUpdateRequest{}
			json.Unmarshal(msg, &r)
			api.mochi.UpdateOwnProfile(r.NameFirst, r.NameLast, nil)

		case "ownProfileGet":
			api.store.HandleOwnProfile(func(p store.OwnProfile) {
				// fmt.Println("Handling own profile", p)
				write(conn, p)
			})
			p, _ := api.store.GetOwnProfile()
			// fmt.Println("Handling old own profile", p)
			if err := write(conn, p); err != nil {
				panic(err)
			}

		case "contactAdd":
			r := ContactAddRequest{}
			json.Unmarshal(msg, &r)
			api.mochi.AddContact(r.IdentityKey, r.Alias)

		case "contactUpdate":
			r := ContactUpdateRequest{}
			json.Unmarshal(msg, &r)
			api.mochi.UpdateContact(r.IdentityKey, r.Alias)

		case "conversationsGet":
			api.store.HandleConversations(func(c store.Conversation) {
				// fmt.Println("Handling conv", c)
				write(conn, c)
			})
			cs, _ := api.store.GetConversations()
			for _, c := range cs {
				// fmt.Println("Handling old conv", c)
				if err := write(conn, c); err != nil {
					panic(err)
				}
			}

		case "conversationStart":
			r := ConversationStartRequest{}
			json.Unmarshal(msg, &r)
			api.mochi.CreateConversation(r.Name, r.Topic)

		case "conversationJoin":
			r := ConversationJoinRequest{}
			json.Unmarshal(msg, &r)
			api.mochi.JoinConversation(r.ConversationHash)

		case "messagesGet":
			r := MessagesGetRequest{}
			json.Unmarshal(msg, &r)
			api.store.HandleMessages(func(m store.Message) {
				if m.ConversationHash != r.Conversation {
					// fmt.Println("Handling msg, ignoring", m)
					return
				}
				// fmt.Println("Handling msg", m)
				write(conn, m)
			})
			ms, _ := api.store.GetMessages(r.Conversation)
			for _, m := range ms {
				// fmt.Println("Handling old msg", m)
				if err := write(conn, m); err != nil {
					panic(err)
				}
			}

		case "messageCreate":
			r := MessageCreateRequest{}
			json.Unmarshal(msg, &r)
			if err := api.mochi.CreateMessage(r.Conversation, r.Body); err != nil {
				logger.Error("could create message", log.Error(err))
			}
		}

	}
}

func write(conn *wsConn, v interface{}) error {
	if o, ok := v.(object.Object); ok {
		o.Set("_hash:s", object.NewHash(o).String())
		v = o
	}
	// b, _ := json.Marshal(v)
	// fmt.Println("sending", string(b))
	conn.lock.Lock()
	defer conn.lock.Unlock()
	return conn.conn.WriteJSON(v)
}

func getIdenticon(key string) []byte {
	ic, err := identicon.New(key, &identicon.Options{
		BackgroundColor: identicon.RGB(240, 240, 240),
		ImageSize:       500,
	})
	if err != nil {
		panic(err)
	}
	buf := &bytes.Buffer{}
	err = png.Encode(buf, ic)
	if err != nil {
		panic(err)
	}
	return buf.Bytes()
	// return base64.StdEncoding.EncodeToString(b)
}

// func (api *API) tell(conn *wsConn, conversation object.Hash, text string) error {
// 	m := ConversationMessageAdded{
// 		Datetime: time.Now().Format(time.RFC3339),
// 		Body:     text,
// 		// Owners:   []crypto.PublicKey{api.local.GetPeerPublicKey()},
// 		Stream: conversation,
// 	}
// 	o := m.ToObject()
// 	o.Set("_system:b", true)
// 	return write(conn, o)
// }
