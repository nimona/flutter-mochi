package daemon

import (
	"fmt"
	"os"
	"os/user"
	"path"
	"path/filepath"
	"runtime"
	"strings"
	"sync"
	"time"

	"mochi.io/internal/api"
	"mochi.io/internal/mochi"
	"mochi.io/internal/store"
	"nimona.io/pkg/context"
	"nimona.io/pkg/crypto"
	"nimona.io/pkg/daemon"
	"nimona.io/pkg/daemon/config"
	"nimona.io/pkg/log"
	"nimona.io/pkg/version"
)

var (
	wg      = sync.WaitGroup{}
	rw      = sync.RWMutex{}
	loaded  = false
	loading = false
)

func StartDaemon() string {
	rw.RLock()
	if loaded == true {
		rw.RUnlock()
		return "was-already-started"
	}
	if loading == true {
		rw.RUnlock()
		wg.Wait()
		return "was-loading,now-started"
	}
	rw.RUnlock()
	rw.Lock()
	loading = true
	wg.Add(1)
	rw.Unlock()
	go func() {
		done, _ := startDaemon(10100, 10800)
		wg.Done()
		<-done
		rw.Lock()
		loaded = false
		loading = false
		rw.Unlock()
	}()
	wg.Wait()
	rw.Lock()
	loaded = true
	rw.Unlock()
	return "just-started"
}

// startDaemon is called when the method startDaemon is invoked by
// the dart code.
func startDaemon(apiPort, tcpPort int) (<-chan bool, error) {
	if err := os.Setenv("BIND_LOCAL", "true"); err != nil {
		log.DefaultLogger.Fatal("err setting env", log.Error(err))
	}
	if err := os.Setenv("BIND_PRIVATE", "true"); err != nil {
		log.DefaultLogger.Fatal("err setting env", log.Error(err))
	}
	if err := os.Setenv("UPNP", "true"); err != nil {
		log.DefaultLogger.Fatal("err setting env", log.Error(err))
	}

	os.Setenv("NIMONA_API_HOST", "0.0.0.0")

	ctx := context.New(
		context.WithCorrelationID("nimona"),
	)

	logger := log.FromContext(ctx).With(
		log.String("build.version", version.Version),
		log.String("build.commit", version.Commit),
		log.String("build.timestamp", version.Date),
	)

	// HACK this is to migrate older versions of the app to the new path
	if usr, err := user.Current(); err == nil {
		oldPath := filepath.Join(usr.HomeDir, ".mochi-10100")
		newPath := filepath.Join(usr.HomeDir, ".mochi")
		_, oldErr := os.Stat(oldPath)
		_, newErr := os.Stat(newPath)
		if oldErr == nil && newErr != nil {
			os.Rename(oldPath, newPath)
		}
	}

	// load config
	logger.Info("loading config file")
	config := config.New()
	switch runtime.GOOS {
	case "darwin":
		// IOS
		if strings.HasPrefix(runtime.GOARCH, "arm") {
			config.Path = filepath.Join("${HOME}", "Documents", ".mochi")
			break
		}
		// MacOS
		config.Path = filepath.Join("${HOME}", ".mochi")
	default:
		config.Path = filepath.Join("${HOME}", ".mochi")
	}
	if err := config.Load(); err != nil {
		logger.Fatal("could not load config file", log.Error(err))
	}

	config.API.Port = apiPort
	config.Peer.TCPPort = tcpPort

	// create peer key pair if it does not exist
	if config.Peer.PeerKey == "" {
		logger.Info("creating new peer key pair")
		peerKey, err := crypto.GenerateEd25519PrivateKey()
		if err != nil {
			logger.Fatal("could not generate peer key", log.Error(err))
		}
		config.Peer.PeerKey = peerKey
	}

	fmt.Println(">>> PEER PUB", config.Peer.PeerKey.PublicKey())

	if err := os.MkdirAll(config.Path, os.ModePerm); err != nil {
		logger.Fatal("could not create config dir", log.Error(err))
	}

	logger.Info("loaded config", log.Any("config", config))

	d, err := daemon.New(ctx, config)
	if err != nil {
		logger.Fatal("could not construct daemon", log.Error(err))
	}

	fmt.Println(">>> ADDRS", d.LocalPeer.GetAddresses())

	// print some info
	nlogger := logger.With(
		log.Strings("addresses", d.LocalPeer.GetAddresses()),
		log.String("peer", config.Peer.PeerKey.PublicKey().String()),
	)

	fmt.Println(">>> ADDRS", d.LocalPeer.GetAddresses())

	ik := config.Peer.IdentityKey
	if ik != "" {
		nlogger = nlogger.With(
			log.String("identity", ik.PublicKey().String()),
		)
	}

	nlogger.Info("starting HTTP API")

	store, _ := store.New(path.Join(config.Path, "mochi.db"))
	mochi, _ := mochi.New(config, store, d)

	// construct api server
	apiServer := api.New(
		config,
		mochi,
		store,
		version.Version,
		version.Commit,
		version.Date,
		config.API.Token,
	)

	apiAddress := fmt.Sprintf("%s:%d", config.API.Host, config.API.Port)
	logger.Info(
		"starting http server",
		log.String("address", apiAddress),
	)

	done := make(chan bool)
	go func() {
		apiServer.Serve(apiAddress) // nolint: errcheck
		done <- true
	}()

	time.Sleep(250 * time.Millisecond)

	return done, nil
}
