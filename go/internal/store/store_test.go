package store

import (
	"testing"
	"time"

	"github.com/stretchr/testify/require"
)

func TestStore_GetConversations(t *testing.T) {
	dbPath := "test-sqlite-" + time.Now().Format("2006-01-02-15-04-05") + ".db"
	s, err := New(dbPath)
	require.NoError(t, err)
	require.NotNil(t, s)

	// create conversation
	c := Conversation{
		Hash:                 "c1",
		Name:                 "name",
		Topic:                "topic",
		UnreadMessagesLatest: []Message{},
		Participants:         []Participant{},
		Messages:             []Message{},
	}
	err = s.PutConversation(c)
	require.NoError(t, err)

	// get conversation
	cs, err := s.GetConversations()
	require.NoError(t, err)
	require.Len(t, cs, 1)

	// create profile
	p := Profile{
		Key:       "f00",
		NameFirst: "John",
		NameLast:  "Doe",
	}
	err = s.AddProfile(p)
	require.NoError(t, err)

	// get profile
	ps, err := s.GetProfiles()
	require.NoError(t, err)
	require.Len(t, ps, 1)
	require.Equal(t, p, ps[0])

	// create contact
	cn := Contact{
		Key:   p.Key,
		Alias: "local",
	}
	err = s.AddContact(cn)
	require.NoError(t, err)

	// create participant
	pa := Participant{
		ProfileKey:       p.Key,
		ConversationHash: c.Hash,
	}
	err = s.AddParticipant(pa)
	require.NoError(t, err)

	// create message
	m := Message{
		Hash:             "m1",
		ProfileKey:       p.Key,
		ConversationHash: c.Hash,
		Body:             "foo",
		Sent:             time.Now().Add(time.Second * 10).UTC(),
	}
	err = s.AddMessage(m)
	require.NoError(t, err)

	// get conversation
	cs, err = s.GetConversations()
	require.NoError(t, err)
	require.Len(t, cs, 1)

	// check relationships for participant
	require.Equal(t, "f00/c1", cs[0].Participants[0].ID)
	require.Equal(t, "c1", cs[0].Participants[0].ConversationHash)
	require.Equal(t, "f00", cs[0].Participants[0].ProfileKey)

	// check relationships for participant.profile
	require.Equal(t, "f00", cs[0].Participants[0].Profile.Key)
	require.Equal(t, "John", cs[0].Participants[0].Profile.NameFirst)

	// check relationships for participant.profile.contact
	require.Equal(t, "f00", cs[0].Participants[0].Profile.Contact.Key)
	require.Equal(t, "local", cs[0].Participants[0].Profile.Contact.Alias)

	// check relationships for message
	require.Equal(t, "m1", cs[0].Messages[0].Hash)
	require.Equal(t, "f00", cs[0].Messages[0].ProfileKey)
	require.Equal(t, "f00/c1", cs[0].Messages[0].ParticipantID)

	// check relationships for message.participant
	require.Equal(t, "f00/c1", cs[0].Messages[0].Participant.ID)
	require.Equal(t, "c1", cs[0].Messages[0].Participant.ConversationHash)
	require.Equal(t, "f00", cs[0].Messages[0].Participant.ProfileKey)

	// check relationships for participant.contact
	require.Equal(t, "f00", cs[0].Messages[0].Participant.Contact.Key)
	require.Equal(t, "local", cs[0].Messages[0].Participant.Contact.Alias)

	// check relationships for message.participant.profile
	require.Equal(t, "f00", cs[0].Messages[0].Participant.Profile.Key)
	require.Equal(t, "John", cs[0].Messages[0].Participant.Profile.NameFirst)

	// check relationships for participant.profile.contact
	require.Equal(t, "f00", cs[0].Messages[0].Participant.Profile.Contact.Key)
	require.Equal(t, "local", cs[0].Messages[0].Participant.Profile.Contact.Alias)

	// get messages
	ms, err := s.GetMessages(c.Hash)
	require.NoError(t, err)
	require.Len(t, ms, 1)

	// check relationships for message
	require.Equal(t, "m1", ms[0].Hash)
	require.Equal(t, "f00", ms[0].ProfileKey)
	require.Equal(t, "f00/c1", ms[0].ParticipantID)

	// check relationships for message.participant
	require.Equal(t, "f00/c1", ms[0].Participant.ID)
	require.Equal(t, "c1", ms[0].Participant.ConversationHash)
	require.Equal(t, "f00", ms[0].Participant.ProfileKey)

	// check relationships for message.participant.profile
	require.Equal(t, "f00", ms[0].Participant.Profile.Key)
	require.Equal(t, "John", ms[0].Participant.Profile.NameFirst)
}

func TestStore_OwnProfile(t *testing.T) {
	dbPath := "test-sqlite-own-profiles-" + time.Now().Format("2006-01-02-15-04-05") + ".db"
	s, err := New(dbPath)
	require.NoError(t, err)
	require.NotNil(t, s)

	c := OwnProfile{
		ID:        1,
		NameFirst: "John",
		NameLast:  "Doe",
	}
	err = s.UpdateOwnProfile(c)
	require.NoError(t, err)

	r, err := s.GetOwnProfile()
	require.NoError(t, err)
	require.Equal(t, c, r)

	c.DisplayPicture = "foo"

	err = s.UpdateOwnProfile(c)
	require.NoError(t, err)

	r, err = s.GetOwnProfile()
	require.NoError(t, err)
	require.Equal(t, c, r)
}

func TestStore_Profile(t *testing.T) {
	dbPath := "test-sqlite-profiles-" + time.Now().Format("2006-01-02-15-04-05") + ".db"
	s, err := New(dbPath)
	require.NoError(t, err)
	require.NotNil(t, s)

	// create profile
	p := Profile{
		Key:       "f00",
		NameFirst: "John",
		NameLast:  "Doe",
	}
	err = s.AddProfile(p)
	require.NoError(t, err)

	// get profile
	ps, err := s.GetProfiles()
	require.NoError(t, err)
	require.Equal(t, p, ps[0])

	// update profile
	p.DisplayPicture = "foo"

	err = s.AddProfile(p)
	require.NoError(t, err)

	// get profile
	ps, err = s.GetProfiles()
	require.NoError(t, err)
	require.Equal(t, p, ps[0])

	// create contact
	c := Contact{
		Key:   p.Key,
		Alias: "local",
	}
	err = s.AddContact(c)
	require.NoError(t, err)

	// get contact
	cs, err := s.GetContacts()
	require.NoError(t, err)
	require.Len(t, cs, 1)
	require.Equal(t, "local", cs[0].Alias)
	require.Equal(t, "John", cs[0].Profile.NameFirst)
}
