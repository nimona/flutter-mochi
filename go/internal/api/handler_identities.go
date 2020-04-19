package api

import (
	"errors"
	"fmt"
	"net/http"
	"regexp"
	"strings"

	"github.com/tyler-smith/go-bip39"

	"nimona.io/pkg/crypto"
	"nimona.io/pkg/http/router"
)

var (
	charRegex  = regexp.MustCompile("[^a-zA-Z ]+")
	spaceRegex = regexp.MustCompile("\\s+")
)

type IdentityLoadRequest struct {
	Mnemonic string `json:"mnemonic"`
}

// HandlePutIdentities -
func (api *API) HandlePutIdentities(c *router.Context) {
	req := &IdentityLoadRequest{}
	if err := c.BindBody(req); err != nil {
		c.AbortWithError(500, err)
		return
	}

	mnemonicClean := req.Mnemonic
	mnemonicClean = charRegex.ReplaceAllString(mnemonicClean, " ")
	mnemonicClean = spaceRegex.ReplaceAllString(mnemonicClean, " ")
	mnemonicClean = strings.TrimSpace(mnemonicClean)

	if mnemonicClean == "" {
		c.AbortWithError(400, errors.New("missing mnemonic"))
		return
	}
	if !bip39.IsMnemonicValid(mnemonicClean) {
		c.AbortWithError(400, errors.New("invalid mnemonic"))
		return
	}

	seed, err := bip39.EntropyFromMnemonic(mnemonicClean)
	if err != nil {
		c.AbortWithError(400, err)
		return
	}

	key := crypto.NewPrivateKey(seed)
	if err := api.mochi.IdentityLoad(key); err != nil {
		c.AbortWithError(400, err)
		return
	}
	c.JSON(http.StatusOK, nil)
}

type IdentityCreateRequest struct {
	NameFirst      string `json:"nameFirst"`
	NameLast       string `json:"nameLast"`
	DisplayPicture string `json:"displayPicture"`
}

// HandlePostIdentities -
func (api *API) HandlePostIdentities(c *router.Context) {
	fmt.Println("--------------")
	fmt.Println("--------------")
	fmt.Println("--------------")
	fmt.Println("--------------")
	fmt.Println("--------------")
	fmt.Println("--------------")
	fmt.Println("--------------")
	fmt.Println("--------------")
	fmt.Println("--------------")
	fmt.Println("POST ID")
	req := &IdentityCreateRequest{}
	if err := c.BindBody(req); err != nil {
		c.AbortWithError(500, err)
		return
	}

	fmt.Println("GEN ID")
	key, _ := crypto.GenerateEd25519PrivateKey()
	if err := api.mochi.IdentityLoad(key); err != nil {
		c.AbortWithError(400, err)
		return
	}

	fmt.Println("UPD PROF")
	if err := api.mochi.UpdateOwnProfile(
		req.NameFirst,
		req.NameLast,
		req.DisplayPicture,
	); err != nil {
		c.AbortWithError(400, err)
		return
	}

	fmt.Println("DONE")
	c.JSON(http.StatusOK, nil)
}
