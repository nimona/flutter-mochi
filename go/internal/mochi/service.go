package mochi

import (
	"bytes"
	"errors"
	"fmt"
	"image/png"
	"io/ioutil"
	"os"
	"strings"
	"sync"
	"time"

	notifier "github.com/geoah/go-nimona-notifier"
	"github.com/tsdtsdtsd/identicon"

	"nimona.io/pkg/context"
	"nimona.io/pkg/crypto"
	"nimona.io/pkg/daemon"
	"nimona.io/pkg/object"
	"nimona.io/pkg/peer"
	"nimona.io/pkg/sqlobjectstore"

	"mochi.io/internal/rand"
	"mochi.io/internal/store"
)

// Mochi is the main service that contains business logic
type Mochi struct {
	store  *store.Store
	daemon *daemon.Daemon
}

func getAssetsPath() string {
	assetsPath := "./go/assets"
	cwd, _ := os.Getwd()
	if strings.HasSuffix(strings.Trim(cwd, "/"), "Resources") {
		assetsPath = "../MacOS/assets"
	}
	return assetsPath
}

var (
	dpLock = sync.RWMutex{}
	dpMap  = map[string]string{}
)

func getConversationDisplayPicture(h string) string {
	dpLock.RLock()
	if v, ok := dpMap[h]; ok {
		dpLock.RUnlock()
		return v
	}
	dpLock.RUnlock()
	dpLock.Lock()
	defer dpLock.Unlock()

	p := "/tmp/nimona-mochi-conversation-" + h + ".png"
	if _, err := os.Stat(p); err == nil {
		return p
	}
	if err := ioutil.WriteFile(p, getIdenticon(h), 0644); err != nil {
		return ""
	}
	return p
}

// New returns a new mochi service given a store
func New(store *store.Store, daemon *daemon.Daemon) (*Mochi, error) {
	m := &Mochi{
		store:  store,
		daemon: daemon,
	}

	p, _ := m.store.GetOwnProfile()
	if p.Key == "" {
		p.Key = m.daemon.LocalPeer.GetIdentityPublicKey().String()
		m.store.UpdateOwnProfile(p)
	}

	go m.handleStreams()

	return m, nil
}

func (m *Mochi) handleStreams() {
	s := m.daemon.Store.Subscribe(
		sqlobjectstore.FilterByObjectType("mochi.io/**"),
	)
	for {
		o, err := s.Next()
		if err != nil {
			return
		}
		switch o.GetType() {
		case "mochi.io/conversation.Created":
			v := ConversationCreated{}
			if err := v.FromObject(o); err != nil {
				continue
			}

			// create conversation and store
			c := store.Conversation{
				Hash:  object.NewHash(o).String(),
				Name:  v.Name,
				Topic: v.Topic,
			}
			m.store.AddConversation(c)
			for _, owner := range v.Owners {
				m.store.AddParticipant(store.Participant{
					ProfileKey:       owner.String(),
					ConversationHash: c.Hash,
					HasAccepted:      true,
				})
			}

		case "mochi.io/conversation.ParticipantInvited":
			v := ConversationParticipantInvited{}
			if err := v.FromObject(o); err != nil {
				continue
			}

			// create participant and store
			m.store.AddParticipant(store.Participant{
				ConversationHash: o.GetStream().String(),
				ProfileKey:       v.PublicKey.String(),
			})

		case "mochi.io/conversation.ParticipantJoined":
			v := ConversationParticipantJoined{}
			if err := v.FromObject(o); err != nil {
				continue
			}

			// create participant and store
			m.store.AddParticipant(store.Participant{
				ConversationHash: o.GetStream().String(),
				ProfileKey:       v.Owners[0].String(),
				HasAccepted:      true,
			})

		case "mochi.io/conversation.ParticipantProfileUpdated":
			v := ConversationParticipantProfileUpdated{}
			if err := v.FromObject(o); err != nil {
				continue
			}

			if v.Profile == nil {
				continue
			}

			// create profile and store
			m.store.AddProfile(store.Profile{
				Key:       v.Owners[0].String(),
				NameFirst: v.Profile.NameFirst,
				NameLast:  v.Profile.NameLast,
			})

			m.store.AddParticipant(store.Participant{
				ProfileKey:       v.Owners[0].String(),
				ConversationHash: v.Stream.String(),
				HasAccepted:      true,
			})

		case "mochi.io/conversation.MessageAdded":
			v := ConversationMessageAdded{}
			if err := v.FromObject(o); err != nil {
				continue
			}

			// create message and store
			t, _ := time.Parse(time.RFC3339, v.Datetime)
			p := store.Message{
				ConversationHash: o.GetStream().String(),
				ProfileKey:       v.Owners[0].String(),
				Body:             v.Body,
				Hash:             object.NewHash(o).String(),
				Sent:             t,
			}
			m.store.AddMessage(p)

			if time.Now().Sub(p.Sent).Seconds() < 60 &&
				m.daemon.LocalPeer.GetIdentityPublicKey().String() != p.ProfileKey {
				msg, err := m.store.GetMessage(p.Hash)
				if err != nil {
					fmt.Println("could not get message for notification")
					continue
				}
				con, err := m.store.GetConversation(p.ConversationHash)
				if err != nil {
					fmt.Println("could not get conversation for notification")
					continue
				}
				note := notifier.NewNotification(msg.Body)
				note.Title = "New message"
				name := strings.Join(
					[]string{
						msg.Participant.Profile.NameFirst,
						msg.Participant.Profile.NameLast,
					}, " ",
				)
				if name != "" {
					note.Title = name
				}
				note.Subtitle = con.Name
				note.Sound = notifier.Basso
				note.Group = "io.nimona.mochi"
				note.Sender = "io.nimona.mochi"
				note.Link = "io.nimona.mochi"
				cdp := getConversationDisplayPicture(con.Hash)
				if cdp != "" {
					note.ContentImage = getConversationDisplayPicture(con.Hash)
				}
				// note.AppIcon = getConversationDisplayPicture(con.Hash)
				if err := note.Push(); err != nil {
					fmt.Println("could not send notification", err)
				}
			}
		}
	}
}

// CreateMessage and store it given a conversation and body, or error
func (m *Mochi) CreateMessage(conversationHash, body string) error {
	if conversationHash == "" {
		return errors.New("missing conversation hash")
	}

	if body == "" {
		return errors.New("missing message body")
	}

	v := ConversationMessageAdded{
		Stream:   object.Hash(conversationHash),
		Body:     body,
		Datetime: time.Now().UTC().Format(time.RFC3339),
		Owners: []crypto.PublicKey{
			m.daemon.LocalPeer.GetIdentityPublicKey(),
		},
	}

	// add object to our peer
	o := v.ToObject()
	if err := m.daemon.Orchestrator.Put(o); err != nil {
		return err
	}

	return nil
}

// CreateConversation and store it given a name and topic, or error
func (m *Mochi) CreateConversation(name, topic string) error {
	if name == "" {
		return errors.New("missing name")
	}

	// create new stream
	v := ConversationCreated{
		Name:  name,
		Topic: topic,
		Nonce: rand.String(32),
		Owners: []crypto.PublicKey{
			m.daemon.LocalPeer.GetIdentityPublicKey(),
		},
		Datetime: time.Now().Format(time.RFC3339),
	}

	// add object to our peer
	o := v.ToObject()
	if err := m.daemon.Orchestrator.Put(o); err != nil {
		return err
	}

	return nil
}

// JoinConversation based on hash, or error
func (m *Mochi) JoinConversation(conversationHash string) error {
	// retrieve conversation stream
	ctx := context.Background()
	rootHash := object.Hash(conversationHash)
	graph, err := m.daemon.Orchestrator.Sync(
		ctx,
		rootHash,
		peer.LookupByContentHash(rootHash),
	)
	fmt.Println(">>>> FOUND", len(graph.Objects), err)
	if err != nil {
		return err
	}

	// create new stream
	v := StreamSubcribe{
		Nonce: rand.String(32),
		Owners: []crypto.PublicKey{
			m.daemon.LocalPeer.GetIdentityPublicKey(),
		},
		Stream: rootHash,
	}

	// add object to our peer
	o := v.ToObject()
	if err := m.daemon.Orchestrator.Put(o); err != nil {
		return err
	}

	return nil
}

// AddContact and store it given a key and an alias, or error
func (m *Mochi) AddContact(identityKey, alias string) error {
	if identityKey == "" {
		return errors.New("missing identity key")
	}
	if alias == "" {
		return errors.New("missing alias")
	}
	// TODO find and retrieve profile from network
	c := store.Contact{
		Key:   identityKey,
		Alias: alias,
	}
	return m.store.AddContact(c)
}

// UpdateOwnProfile and store it given a first and last name, or error
// TODO(geoah) add display picture support
func (m *Mochi) UpdateOwnProfile(nameFirst, nameLast string, displayPicture []byte) error {
	op, _ := m.store.GetOwnProfile()
	op.NameFirst = nameFirst
	op.NameLast = nameLast
	if err := m.store.UpdateOwnProfile(op); err != nil {
		return err
	}

	p := store.Profile{
		Key:       m.daemon.LocalPeer.GetIdentityPublicKey().String(),
		NameFirst: nameFirst,
		NameLast:  nameLast,
	}
	if err := m.store.AddProfile(p); err != nil {
		return err
	}

	cs, err := m.store.GetConversations()
	if err != nil {
		return err
	}

	for _, c := range cs {
		m.daemon.Orchestrator.Put(ConversationParticipantProfileUpdated{
			Stream: object.Hash(c.Hash),
			Owners: []crypto.PublicKey{
				m.daemon.LocalPeer.GetIdentityPublicKey(),
			},
			Profile: &IdentityProfile{
				NameFirst: nameFirst,
				NameLast:  nameLast,
				Owners: []crypto.PublicKey{
					m.daemon.LocalPeer.GetIdentityPublicKey(),
				},
			},
			Datetime: time.Now().UTC().Format(time.RFC3339),
		}.ToObject())
	}

	return nil
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
