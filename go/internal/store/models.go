package store

import "time"

// Conversation -
type Conversation struct {
	Hash                 string    `json:"hash" gorm:"primary_key"`
	Name                 string    `json:"name"`
	Topic                string    `json:"topic"`
	DisplayPicture       string    `json:"displayPicture"`
	LastMessageRead      time.Time `json:"lastMessageRead"`
	UnreadMessagesCount  int       `json:"unreadMessagesCount" gorm:"-"`
	UnreadMessagesLatest []Message `json:"unreadMessagesLatest" gorm:"-"`
}

// Message -
type Message struct {
	Hash             string    `json:"hash" gorm:"primary_key"`
	ConversationHash string    `json:"-"`
	Body             string    `json:"body"`
	Sent             time.Time `json:"sent"`
	ProfileKey       Profile   `json:"sender"`
	IsEdited         bool      `json:"isEdited"`
}

// Profile -
type Profile struct {
	Key            string `json:"key" gorm:"primary_key"`
	NameFirst      string `json:"nameFirst"`
	NameLast       string `json:"nameLast"`
	LocalAlias     string `json:"localAlias"`
	DisplayPicture string `json:"displayPicture"`
}

// OwnProfile -
type OwnProfile struct {
	ID             int    `json:"id" gorm:"primary_key"`
	Key            string `json:"key"`
	NameFirst      string `json:"nameFirst"`
	NameLast       string `json:"nameLast"`
	LocalAlias     string `json:"localAlias"`
	DisplayPicture string `json:"displayPicture"`
}
