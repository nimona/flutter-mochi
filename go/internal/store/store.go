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

// ProfileHandler for registering for Profiles
type ProfileHandler func(Profile)

// Store deals with storing and retrieving all mochi related objects
type Store struct {
	db *gorm.DB

	lock sync.RWMutex

	conversationHandlers []ConversationHandler
	messageHandlers      []MessageHandler
	profileHandlers      []ProfileHandler
}

// New returns a new store or errors
func New(dbPath string) (*Store, error) {
	db, err := gorm.Open("sqlite3", dbPath)
	if err != nil {
		return nil, err
	}

	db.AutoMigrate(&Conversation{})
	db.AutoMigrate(&Message{})
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
func (s *Store) HandleProfiles(h ProfileHandler) {
	s.lock.Lock()
	s.profileHandlers = append(s.profileHandlers, h)
	s.lock.Unlock()
}

// AddProfile to the store and publish it
func (s *Store) AddProfile(p Profile) error {
	err := s.db.FirstOrCreate(&p).Error
	if err != nil {
		return err
	}

	s.lock.RLock()
	for _, h := range s.profileHandlers {
		h(p)
	}
	s.lock.RUnlock()

	return nil
}

// GetProfiles returns all conversations
func (s *Store) GetProfiles() ([]Profile, error) {
	ps := []Profile{}
	if err := s.db.Find(&ps).Error; err != nil {
		return nil, err
	}

	return ps, nil
}

// AddConversation to the store and publish it
func (s *Store) AddConversation(c Conversation) error {
	err := s.db.FirstOrCreate(&c).Error
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
	if err := s.db.Find(&cs).Error; err != nil {
		return nil, err
	}

	for i, c := range cs {
		total, ms, err := s.getMessagesForConversation(c)
		if err != nil {
			return nil, err
		}

		cs[i].UnreadMessagesCount = total
		cs[i].UnreadMessagesLatest = ms
	}

	return cs, nil
}

// GetMessages returns messages for conversation
func (s *Store) GetMessages(conversationHash string) ([]Message, error) {
	ms := []Message{}
	if err := s.db.Where(
		"conversation_hash = ?",
		conversationHash,
	).Find(&ms).Error; err != nil {
		return nil, err
	}

	return ms, nil
}

func (s *Store) getMessagesForConversation(c Conversation) (int, []Message, error) {
	// TODO(geoah) order messages
	ms := []Message{}
	if err := s.db.Where(
		"conversation_hash = ? AND sent > ?",
		c.Hash,
		c.LastMessageRead,
	).Find(&ms).Error; err != nil {
		return 0, nil, err
	}

	total := len(ms)

	if len(ms) > 3 {
		ms = ms[:3]
	}

	return total, ms, nil
}

// AddMessage to the store and publish it
func (s *Store) AddMessage(m Message) error {
	err := s.db.FirstOrCreate(&m).Error
	if err != nil {
		return err
	}

	s.lock.RLock()
	for _, h := range s.messageHandlers {
		h(m)
	}
	s.lock.RUnlock()

	c := Conversation{}
	if err := s.db.Where(
		"hash = ?",
		m.ConversationHash,
	).First(&c).Error; err != nil {
		return err
	}

	if m.Sent.Before(c.LastMessageRead) {
		return nil
	}

	total, ms, err := s.getMessagesForConversation(c)
	if err != nil {
		return err
	}

	c.UnreadMessagesCount = total
	c.UnreadMessagesLatest = ms

	s.lock.RLock()
	for _, h := range s.conversationHandlers {
		h(c)
	}
	s.lock.RUnlock()

	return nil
}
