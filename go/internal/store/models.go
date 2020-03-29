package store

import "time"

// * conversation
//   * message
//     * participant
//       * profile
//         * contact
//   * participant
//     * profile
//       * contact
// * contact
//   * profile
// * ownProfile

// Conversation -
type Conversation struct {
	Hash                 string        `json:"hash," gorm:"primary_key"`
	Name                 string        `json:"name,"`
	Topic                string        `json:"topic,"`
	DisplayPicture       string        `json:"displayPicture,"`
	LastMessageRead      time.Time     `json:"lastMessageRead,"`
	UnreadMessagesCount  int           `json:"unreadMessagesCount," gorm:"-"`
	UnreadMessagesLatest []Message     `json:"unreadMessagesLatest," gorm:"PRELOAD:false"`
	Participants         []Participant `json:"participants,"`
	Messages             []Message     `json:"messages,"`
	Updated              time.Time     `json:"updated" gorm:"default:'1970-01-01 00:00:00.00000+00:00'"`
}

// Message -
type Message struct {
	Hash             string      `json:"hash" gorm:"primary_key"`
	ConversationHash string      `json:"-"`
	ProfileKey       string      `json:"-"`
	Body             string      `json:"body"`
	Sent             time.Time   `json:"sent"`
	ParticipantID    string      `json:"-"`
	Participant      Participant `json:"participant" gorm:"foreignKey:participantID"`
	IsEdited         bool        `json:"isEdited"`
	IsRead           bool        `json:"isRead"`
}

// MessageView is not a real model but rather a joined message+profile
type MessageView struct {
	Hash             string    `json:"hash"`
	ConversationHash string    `json:"conversationHash"`
	ProfileKey       string    `json:"profileKey"`
	Body             string    `json:"body"`
	Sent             time.Time `json:"sent"`
	IsEdited         bool      `json:"isEdited"`
	IsRead           bool      `json:"isRead"`
	NameFirst        string    `json:"nameFirst"`
	NameLast         string    `json:"nameLast"`
	Alias            string    `json:"alias"`
	ProfileUpdated   string    `json:"profileUpdated"`
}

// Contact -
type Contact struct {
	Alias   string  `json:"alias"`
	Key     string  `json:"key" gorm:"primary_key"`
	Profile Profile `json:"profile" gorm:"foreignKey:key;PRELOAD:false"`
}

// Participant -
type Participant struct {
	ID               string  `json:"id" gorm:"primary_key"` // key+conversationHash
	ConversationHash string  `json:"-"`
	ProfileKey       string  `json:"key"`
	Profile          Profile `json:"profile"`
	Contact          Contact `json:"contact" gorm:"foreignKey:profileKey"`
	HasAccepted      bool    `json:"has_accepted"`
}

// GetID returns a "composite" key since GORM doesn't support one-to-many with
// composite keys
func (p Participant) GetID() string {
	return p.ProfileKey + "/" + p.ConversationHash
}

// Profile -
type Profile struct {
	Key            string    `json:"key" gorm:"primary_key"`
	NameFirst      string    `json:"nameFirst"`
	NameLast       string    `json:"nameLast"`
	DisplayPicture string    `json:"displayPicture" gorm:"-"`
	Contact        *Contact  `json:"contact" gorm:"foreignKey:key;PRELOAD:false"`
	Updated        time.Time `json:"updated" gorm:"default:'1970-01-01 00:00:00.00000+00:00'"`
}

// OwnProfile -
type OwnProfile struct {
	ID             int       `json:"id" gorm:"primary_key"`
	Key            string    `json:"key"`
	NameFirst      string    `json:"nameFirst"`
	NameLast       string    `json:"nameLast"`
	LocalAlias     string    `json:"alias"`
	DisplayPicture string    `json:"displayPicture" gorm:"-"`
	Updated        time.Time `json:"updated" gorm:"default:'1970-01-01 00:00:00.00000+00:00'"`
}

// DisplayPicture -
type DisplayPicture struct {
	Key     string `json:"key" gorm:"primary_key"`
	DataB64 string `json:"dataB64"`
}
