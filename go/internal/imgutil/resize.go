package imgutil

import (
	"bytes"
	"encoding/base64"
	"image"
	"image/jpeg"

	"github.com/nfnt/resize"
	"github.com/oliamb/cutter"
)

func ResizeBase64(s string, n uint) ([]byte, error) {
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
