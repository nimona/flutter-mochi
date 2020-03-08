package mochi

import (
	"time"

	"nimona.io/pkg/crypto"
	"nimona.io/pkg/daemon"
	"nimona.io/pkg/object"
	"nimona.io/pkg/sqlobjectstore"

	"mochi.io/internal/rand"
	"mochi.io/internal/store"
)

// Mochi is the main service that contains business logic
type Mochi struct {
	store  *store.Store
	daemon *daemon.Daemon
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
		}
	}
}

// CreateMessage and store it given a conversation and body, or error
func (m *Mochi) CreateMessage(conversationHash, body string) error {
	// TODO(geoah) remove, temp
	hash := rand.String(6)
	if body == "" {
		body = rand.Words(rand.Int(25))
	}
	c := store.Message{
		Hash:             hash,
		ConversationHash: conversationHash,
		Body:             body,
		Sent:             time.Now().UTC(),
	}
	return m.store.AddMessage(c)
}

// CreateConversation and store it given a name and topic, or error
func (m *Mochi) CreateConversation(name, topic string) error {
	// TODO(geoah) remove, temp
	if name == "" {
		name = rand.Words(3)
	}
	if topic == "" {
		topic = rand.Words(6)
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

// AddContact and store it given a key and an alias, or error
func (m *Mochi) AddContact(identityKey, alias string) error {
	// TODO(geoah) remove, temp
	if identityKey == "" {
		identityKey = rand.String(6)
	}
	if alias == "" {
		alias = rand.Words(3)
	}
	// TODO find and retrieve profile from network
	c := store.Profile{
		Key:        identityKey,
		LocalAlias: alias,
	}
	return m.store.AddProfile(c)
}

// UpdateOwnProfile and store it given a first and last name, or error
func (m *Mochi) UpdateOwnProfile(nameFirst, nameLast string, displayPicture []byte) error {
	p, _ := m.store.GetOwnProfile()
	p.NameFirst = nameFirst
	p.NameLast = nameLast
	return m.store.UpdateOwnProfile(p)
}
