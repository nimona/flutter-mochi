package store

import (
	"sync"

	"github.com/jinzhu/gorm"

	// required for sql dialect
	_ "github.com/jinzhu/gorm/dialects/sqlite"
)

// ConversationHandler for registering for Conversations
type ConversationHandler func(Conversation)

// MessageHandler for registering for Messages
type MessageHandler func(Message)

// ContactHandler for registering for Contacts
type ContactHandler func(Contact)

// OwnProfileHandler for registering for OwnProfile
type OwnProfileHandler func(OwnProfile)

// Store deals with storing and retrieving all mochi related objects
type Store struct {
	db *gorm.DB

	lock sync.RWMutex

	conversationHandlers []ConversationHandler
	messageHandlers      []MessageHandler
	contactHandlers      []ContactHandler
	ownProfileHandlers   []OwnProfileHandler
}

// New returns a new store or errors
func New(dbPath string) (*Store, error) {
	db, err := gorm.Open("sqlite3", dbPath)
	if err != nil {
		return nil, err
	}

	db = db.Debug()

	db.AutoMigrate(&Contact{})
	db.AutoMigrate(&Conversation{})
	db.AutoMigrate(&Message{})
	db.AutoMigrate(&OwnProfile{})
	db.AutoMigrate(&Participant{})
	db.AutoMigrate(&Profile{})

	return &Store{db: db}, nil
}

// HandleMessages adds a message handler
func (s *Store) HandleMessages(h MessageHandler) {
	s.lock.Lock()
	s.messageHandlers = append(s.messageHandlers, h)
	s.lock.Unlock()
}

// HandleConversations adds a conversation handler
func (s *Store) HandleConversations(h ConversationHandler) {
	s.lock.Lock()
	s.conversationHandlers = append(s.conversationHandlers, h)
	s.lock.Unlock()
}

// HandleProfiles adds a profile handler
func (s *Store) HandleProfiles(h ContactHandler) {
	s.lock.Lock()
	s.contactHandlers = append(s.contactHandlers, h)
	s.lock.Unlock()
}

// HandleOwnProfile adds a own profile handler
func (s *Store) HandleOwnProfile(h OwnProfileHandler) {
	s.lock.Lock()
	s.ownProfileHandlers = append(s.ownProfileHandlers, h)
	s.lock.Unlock()
}

// PutContact to the store and publish it
func (s *Store) PutContact(p Contact) error {
	err := s.db.
		Where(Contact{
			Key: p.Key,
		}).
		Assign(p).
		FirstOrCreate(&p).
		Error
	if err != nil {
		return err
	}

	s.lock.RLock()
	for _, h := range s.contactHandlers {
		h(p)
	}
	s.lock.RUnlock()

	return nil
}

// GetContacts returns all contacts
func (s *Store) GetContacts() ([]Contact, error) {
	ps := []Contact{}
	if err := s.db.
		Set("gorm:auto_preload", true).
		Preload("Profile").
		Find(&ps).
		Error; err != nil {
		return nil, err
	}

	return ps, nil
}

// AddProfile to the store
// TODO(geoah) this should publish various updates for messages,
// contacts, participants, etc
func (s *Store) AddProfile(p Profile) error {
	err := s.db.
		Where(Profile{
			Key: p.Key,
		}).
		Assign(p).
		FirstOrCreate(&p).
		Error
	if err != nil {
		return err
	}

	return nil
}

// GetProfiles returns all profiles
func (s *Store) GetProfiles() ([]Profile, error) {
	ps := []Profile{}
	if err := s.db.
		Set("gorm:auto_preload", true).
		Find(&ps).
		Error; err != nil {
		return nil, err
	}

	return ps, nil
}

// UpdateOwnProfile to the store and publish it
func (s *Store) UpdateOwnProfile(p OwnProfile) error {
	p.ID = 1
	err := s.db.
		Where(OwnProfile{ID: 1}).
		Assign(p).
		FirstOrCreate(&p).
		Error
	if err != nil {
		return err
	}

	s.lock.RLock()
	for _, h := range s.ownProfileHandlers {
		h(p)
	}
	s.lock.RUnlock()

	return nil
}

// GetOwnProfile returns own profile
func (s *Store) GetOwnProfile() (OwnProfile, error) {
	p := OwnProfile{
		ID: 1,
	}
	if err := s.db.Find(&p).Error; err != nil {
		return p, err
	}

	return p, nil
}

// AddParticipant to the store
func (s *Store) AddParticipant(p Participant) error {
	p.ID = p.GetID()
	err := s.db.
		Where(Participant{
			ProfileKey:       p.ProfileKey,
			ConversationHash: p.ConversationHash,
		}).
		Assign(p).
		FirstOrCreate(&p).
		FirstOrCreate(&p).Error
	if err != nil {
		return err
	}

	return nil
}

// AddConversation to the store and publish it
func (s *Store) AddConversation(c Conversation) error {
	err := s.db.
		Where(Conversation{
			Hash: c.Hash,
		}).
		Assign(c).
		FirstOrCreate(&c).
		Error
	if err != nil {
		return err
	}

	s.lock.RLock()
	for _, h := range s.conversationHandlers {
		h(c)
	}
	s.lock.RUnlock()

	return nil
}

// GetConversations returns all conversations
func (s *Store) GetConversations() ([]Conversation, error) {
	cs := []Conversation{}
	if err := s.db.
		Set("gorm:auto_preload", true).
		Preload("Participants.Profile.Contact").
		Preload("Messages.Participant.Profile.Contact").
		Preload("Messages.Participant.Contact").
		// Preload("UnreadMessagesLatest", "is_read = false").
		Find(&cs).
		Error; err != nil {
		return nil, err
	}

	return cs, nil
}

// GetConversation returns a single conversation
func (s *Store) GetConversation(conversationHash string) (Conversation, error) {
	c := Conversation{}
	if err := s.db.
		Set("gorm:auto_preload", true).
		Preload("Participants.Profile.Contact").
		Preload("Messages.Participant.Profile.Contact").
		Preload("Messages.Participant.Contact").
		// Preload("UnreadMessagesLatest", "is_read = false").
		Where(
			"hash = ?",
			conversationHash,
		).
		First(&c).
		Error; err != nil {
		return c, err
	}

	return c, nil
}

// GetMessages returns messages for conversation
func (s *Store) GetMessages(conversationHash string) ([]Message, error) {
	ms := []Message{}
	if err := s.db.
		Set("gorm:auto_preload", true).
		Preload("Participant.Profile").
		Preload("Participant.Profile.Contact").
		Where(
			"conversation_hash = ?",
			conversationHash,
		).
		Order("sent ASC").
		Find(&ms).Error; err != nil {
		return nil, err
	}

	return ms, nil
}

// GetMessage returns message by its hash
func (s *Store) GetMessage(hash string) (Message, error) {
	m := Message{}
	if err := s.db.Set("gorm:auto_preload", true).Where(
		"hash = ?",
		hash,
	).First(&m).Error; err != nil {
		return m, err
	}

	return m, nil
}

// AddMessage to the store and publish it
func (s *Store) AddMessage(m Message) error {
	// set participant id
	m.ParticipantID = Participant{
		ProfileKey:       m.ProfileKey,
		ConversationHash: m.ConversationHash,
	}.GetID()

	err := s.db.
		Where(Message{
			Hash: m.Hash,
		}).
		Assign(m).
		FirstOrCreate(&m).
		Error
	if err != nil {
		return err
	}

	// we need to fetch the message again to load its relationships
	m, err = s.GetMessage(m.Hash)
	if err != nil {
		return err
	}

	s.lock.RLock()
	for _, h := range s.messageHandlers {
		h(m)
	}
	s.lock.RUnlock()

	c := Conversation{}
	if err := s.db.
		Set("gorm:auto_preload", true).
		Preload("Participants.Profile.Contact").
		Preload("Messages.Participant.Profile.Contact").
		Preload("Messages.Participant.Contact").
		Preload("UnreadMessagesLatest", "is_read = false").
		Where(
			"hash = ?",
			m.ConversationHash,
		).First(&c).
		Error; err != nil {
		return err
	}

	if m.Sent.Before(c.LastMessageRead) {
		return nil
	}

	s.lock.RLock()
	for _, h := range s.conversationHandlers {
		h(c)
	}
	s.lock.RUnlock()

	return nil
}
