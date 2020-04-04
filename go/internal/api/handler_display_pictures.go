package api

import (
	"strconv"

	"mochi.io/internal/imgutil"

	"nimona.io/pkg/http/router"
)

// HandleDisplayPictures -
func (api *API) HandleDisplayPictures(c *router.Context) {
	key := c.Param("publicKey")
	size := c.Query("size")
	dp, _ := api.store.GetDisplayPicture(key)
	if dp != "" {
		n, _ := strconv.Atoi(size)
		if b, err := imgutil.ResizeBase64(dp, uint(n)); err == nil {
			c.Header("Content-Type", "image/jpeg")
			c.Header("Content-Length", strconv.Itoa(len(b)))
			c.Writer.Write(b)
			return
		}
	}
	body := getIdenticon(key)
	c.Header("Content-Type", "image/png")
	c.Header("Content-Length", strconv.Itoa(len(body)))
	c.Writer.Write(body)
}
