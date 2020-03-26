package api

import (
	"bytes"
	"encoding/base64"
	"image"
	"image/jpeg"
	"strconv"

	"github.com/nfnt/resize"
	"github.com/oliamb/cutter"

	"nimona.io/pkg/http/router"
)

// HandleDisplayPictures -
func (api *API) HandleDisplayPictures(c *router.Context) {
	key := c.Param("publicKey")
	size := c.Query("size")
	dp, _ := api.store.GetDisplayPicture(key)
	if dp != "" {
		n, _ := strconv.Atoi(size)
		if b, err := r(dp, uint(n)); err == nil {
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

func r(s string, n uint) ([]byte, error) {
	b, err := base64.StdEncoding.DecodeString(s)
	if err != nil {
		return nil, err
	}
	if n == 0 {
		return b, nil
	}
	img, _, err := image.Decode(bytes.NewReader(b))
	if err != nil {
		return nil, err
	}
	img, err = cutter.Crop(img, cutter.Config{
		Width:   1,
		Height:  1,
		Mode:    cutter.Centered,
		Options: cutter.Ratio,
	})
	if err != nil {
		return nil, err
	}
	img = resize.Resize(n, 0, img, resize.Lanczos3)
	buf := new(bytes.Buffer)
	if err := jpeg.Encode(buf, img, &jpeg.Options{
		Quality: 100,
	}); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}
