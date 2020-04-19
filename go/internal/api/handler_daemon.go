package api

import (
	"net/http"

	"nimona.io/pkg/http/router"
)

// HandleGetDaemonInfo -
func (api *API) HandleGetDaemonInfo(c *router.Context) {
	c.JSON(http.StatusOK, api.mochi.GetDaemonInfo())
}
