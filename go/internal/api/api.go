package api

import (
	"expvar"
	"net/http"
	"runtime"
	"runtime/debug"
	"runtime/pprof"
	"time"

	"github.com/zserge/metric"

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

	// HACK until we figure out how to kill connections from the ui side
	lastMessagesWsConn *wsConn
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

	// Some Go internal metrics
	expvar.Publish("go:goroutine", metric.NewGauge("2m1s", "15m30s", "1h1m"))
	expvar.Publish("go:cgocall", metric.NewGauge("2m1s", "15m30s", "1h1m"))
	expvar.Publish("go:alloc", metric.NewGauge("2m1s", "15m30s", "1h1m"))
	expvar.Publish("go:alloc.total", metric.NewGauge("2m1s", "15m30s", "1h1m"))

	go func() {
		for range time.Tick(100 * time.Millisecond) {
			m := &runtime.MemStats{}
			runtime.ReadMemStats(m)
			expvar.Get("go:goroutine").(metric.Metric).Add(float64(runtime.NumGoroutine()))
			expvar.Get("go:cgocall").(metric.Metric).Add(float64(runtime.NumCgoCall()))
			expvar.Get("go:alloc").(metric.Metric).Add(float64(m.Alloc) / 1000000)
			expvar.Get("go:alloc.total").(metric.Metric).Add(float64(m.TotalAlloc) / 1000000)
		}
	}()

	metricsHandler := func(c *router.Context) {
		metric.Handler(metric.Exposed).ServeHTTP(c.Writer, c.Request)
	}
	r.Handle("GET", "/debug/metrics", metricsHandler)

	stackHandler := func(c *router.Context) {
		stack := debug.Stack()
		c.Writer.Write(stack)
		pprof.Lookup("goroutine").WriteTo(c.Writer, 2)
	}
	r.Handle("GET", "/debug/stack", stackHandler)

	r.Handle("GET", "/daemon-info", api.HandleGetDaemonInfo)
	r.Handle("POST", "/identities", api.HandlePostIdentities)
	r.Handle("PUT", "/identities", api.HandlePutIdentities)
	r.Handle("GET", "/conversations/(?P<conversationHash>.+)/mark=read$", api.HandleConversationMarkRead)
	r.Handle("GET", "/displayPictures/(?P<publicKey>.+)$", api.HandleDisplayPictures)
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
