package api

import (
	"net/http"

	"mochi.io/internal/mochi"
	"mochi.io/internal/store"

	"nimona.io/pkg/context"
	"nimona.io/pkg/daemon/config"
	"nimona.io/pkg/http/router"
	"nimona.io/pkg/log"
	"nimona.io/pkg/object"
)

// API for HTTP
type API struct {
	config       *config.Config
	mochi        *mochi.Mochi
	store        *store.Store
	router       *router.Router
	token        string
	version      string
	commit       string
	buildDate    string
	gracefulStop chan bool
	srv          *http.Server
}

// New HTTP API
func New(
	cfg *config.Config,
	mochi *mochi.Mochi,
	store *store.Store,
	version string,
	commit string,
	buildDate string,
	token string,
) *API {
	r := router.New()

	api := &API{
		config:       cfg,
		router:       r,
		mochi:        mochi,
		store:        store,
		version:      version,
		commit:       commit,
		buildDate:    buildDate,
		token:        token,
		gracefulStop: make(chan bool),
	}

	r.Use(api.Cors())

	r.Handle("GET", "/", api.HandleWS)

	return api
}

// Serve HTTP API
func (api *API) Serve(address string) error {
	ctx := context.Background()
	logger := log.FromContext(ctx).Named("api")

	api.srv = &http.Server{
		Addr:    address,
		Handler: api.router,
	}

	go func() {
		if err := api.srv.ListenAndServe(); err != nil &&
			err != http.ErrServerClosed {
			logger.Error("Error serving", log.Error(err))
		}
	}()

	<-api.gracefulStop

	if err := api.srv.Shutdown(ctx); err != nil {
		logger.Error("Failed to shutdown", log.Error(err))
	}

	return nil
}

func (api *API) Stop(c *router.Context) {
	c.Status(http.StatusOK)

	go func() {
		api.gracefulStop <- true
	}()
	return
}

func (api *API) mapObject(o object.Object) map[string]interface{} {
	m := o.ToMap()
	m["_hash"] = object.NewHash(o).String()
	return m
}

func (api *API) mapObjects(os []object.Object) []map[string]interface{} {
	ms := []map[string]interface{}{}
	for _, o := range os {
		ms = append(ms, api.mapObject(o))
	}
	return ms
}
