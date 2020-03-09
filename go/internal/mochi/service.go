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
			p := store.Participant{
				ConversationHash: o.GetStream().String(),
				ProfileKey:       v.PublicKey.String(),
			}
			m.store.AddParticipant(p)

		case "mochi.io/conversation.ParticipantJoined":
			v := ConversationParticipantJoined{}
			if err := v.FromObject(o); err != nil {
				continue
			}

			// create participant and store
			p := store.Participant{
				ConversationHash: o.GetStream().String(),
				ProfileKey:       v.Owners[0].String(),
				HasAccepted:      true,
			}
			m.store.AddParticipant(p)

		case "mochi.io/conversation.ParticipantProfileUpdated":
			v := ConversationParticipantProfileUpdated{}
			if err := v.FromObject(o); err != nil {
				continue
			}

			if v.Profile == nil {
				continue
			}

			// create profile and store
			p := store.Profile{
				Key:       v.Owners[0].String(),
				NameFirst: v.Profile.NameFirst,
				NameLast:  v.Profile.NameLast,
			}
			m.store.AddProfile(p)

		case "mochi.io/conversation.MessageAdded":
			v := ConversationMessageAdded{}
			if err := v.FromObject(o); err != nil {
				continue
			}

			// create message and store
			t, _ := time.Parse(time.RFC3339, v.Datetime)
			p := store.Message{
				ConversationHash: o.GetStream().String(),
				ProfileKey:       v.Signatures[0].Signer.String(),
				Body:             v.Body,
				Hash:             object.NewHash(o).String(),
				Sent:             t,
			}
			m.store.AddMessage(p)
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
		ProfileKey:       m.daemon.LocalPeer.GetIdentityPublicKey().String(),
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

	return nil
}
