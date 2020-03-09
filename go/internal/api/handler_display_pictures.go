package api

import (
	"strconv"

	"nimona.io/pkg/http/router"
)

// HandleDisplayPictures -
func (api *API) HandleDisplayPictures(c *router.Context) {
	body := getIdenticon(c.Param("publicKey"))
	c.Header("Content-Type", "image/png")
	c.Header("Content-Length", strconv.Itoa(len(body)))
	c.Writer.Write(body)
}
