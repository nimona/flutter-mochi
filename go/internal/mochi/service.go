package mochi

import (
	"time"

	"mochi.io/internal/rand"
	"mochi.io/internal/store"
)

// Mochi is the main service that contains business logic
type Mochi struct {
	store *store.Store
}

// New returns a new mochi service given a store
func New(store *store.Store) (*Mochi, error) {
	return &Mochi{
		store: store,
	}, nil
}

// CreateMessage and store it given a conversation and body, or error
func (m *Mochi) CreateMessage(conversationHash, body string) error {
	hash := rand.String(6)
	if body == "" {
		body = hash
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
	hash := rand.String(6)
	if name == "" {
		name = hash
	}
	c := store.Conversation{
		Hash:  hash,
		Name:  name,
		Topic: topic,
	}
	return m.store.AddConversation(c)
}

// AddContact and store it given a key and an alias, or error
func (m *Mochi) AddContact(identityKey, alias string) error {
	if identityKey == "" {
		identityKey = rand.String(6)
	}
	if alias == "" {
		alias = rand.String(6)
	}
	// TODO find and retrieve profile from network
	c := store.Profile{
		Key:        identityKey,
		LocalAlias: alias,
	}
	return m.store.AddProfile(c)
}
