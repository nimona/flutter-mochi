package api

import (
	"net/http"

	"nimona.io/pkg/http/router"
)

// HandleConversationMarkRead -
func (api *API) HandleConversationMarkRead(c *router.Context) {
	conversationHash := c.Param("conversationHash")
	if err := api.mochi.ConversationMarkRead(conversationHash); err != nil {
		c.AbortWithError(500, err)
		return
	}
	c.Writer.WriteHeader(http.StatusOK)
}
