package api

import (
	"net/http"

	"nimona.io/pkg/http/router"
)

// HandleConversationJoin -
func (api *API) HandleConversationJoin(c *router.Context) {
	r := ConversationJoinRequest{}
	if err := c.BindBody(&r); err != nil {
		c.AbortWithError(400, err)
		return
	}

	if err := api.mochi.JoinConversation(r.ConversationHash); err != nil {
		c.AbortWithError(500, err)
		return
	}

	c.Writer.WriteHeader(http.StatusOK)
}
