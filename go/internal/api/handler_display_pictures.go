package api

import (
	"encoding/base64"
	"strconv"

	"nimona.io/pkg/http/router"
)

// HandleDisplayPictures -
func (api *API) HandleDisplayPictures(c *router.Context) {
	key := c.Param("publicKey")
	dp, _ := api.store.GetDisplayPicture(key)
	if dp != "" {
		body, err := base64.StdEncoding.DecodeString(dp)
		if err == nil {
			c.Header("Content-Type", "image/png")
			c.Header("Content-Length", strconv.Itoa(len(body)))
			c.Writer.Write(body)
			return
		}
	}
	body := getIdenticon(key)
	c.Header("Content-Type", "image/png")
	c.Header("Content-Length", strconv.Itoa(len(body)))
	c.Writer.Write(body)
}
