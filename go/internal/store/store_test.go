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

	c := Conversation{
		Hash:                 "c1",
		Name:                 "name",
		Topic:                "topic",
		UnreadMessagesLatest: []Message{},
	}
	err = s.AddConversation(c)
	require.NoError(t, err)

	cs, err := s.GetConversations()
	require.NoError(t, err)
	require.Len(t, cs, 1)
	require.Equal(t, c, cs[0])

	m := Message{
		Hash:             "m1",
		ConversationHash: "c1",
		Body:             "foo",
		Sent:             time.Now().Add(time.Second * 10).UTC(),
	}
	err = s.AddMessage(m)
	require.NoError(t, err)

	cs, err = s.GetConversations()
	require.NoError(t, err)
	require.Len(t, cs, 1)
	require.Len(t, cs[0].UnreadMessagesLatest, 1)
	require.Equal(t, m, cs[0].UnreadMessagesLatest[0])
}

func TestStore_OwnProfile(t *testing.T) {
	dbPath := "test-sqlite-profiles-" + time.Now().Format("2006-01-02-15-04-05") + ".db"
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
