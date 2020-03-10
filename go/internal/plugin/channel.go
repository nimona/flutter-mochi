package plugin

import (
	"fmt"
	"os"
	"path"
	"strconv"
	"time"

	"mochi.io/internal/api"
	"mochi.io/internal/mochi"
	"mochi.io/internal/store"

	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/go-flutter/plugin"

	"nimona.io/pkg/context"
	"nimona.io/pkg/crypto"
	"nimona.io/pkg/daemon"
	"nimona.io/pkg/daemon/config"
	"nimona.io/pkg/dot"
	"nimona.io/pkg/log"
	"nimona.io/pkg/object"
	"nimona.io/pkg/sqlobjectstore"
	"nimona.io/pkg/version"
)

const channelName = "mochi.io/daemon"

// var daemonStarted = false

type NimonaDaemon struct {
}

var _ flutter.Plugin = &NimonaDaemon{}

// InitPlugin creates a MethodChannel and set a HandleFunc to the
// shared 'startDaemon' method.
func (p *NimonaDaemon) InitPlugin(messenger plugin.BinaryMessenger) error {
	channel := plugin.NewMethodChannel(
		messenger,
		channelName,
		plugin.StandardMethodCodec{},
	)
	channel.HandleFunc("startDaemon", startDaemon)
	return nil // no error
}

// startDaemon is called when the method startDaemon is invoked by
// the dart code.
func startDaemon(arguments interface{}) (interface{}, error) {
	// if daemonStarted == true {
	// 	return nil, nil
	// }
	// fmt.Println("___________________", arguments)
	// daemonStarted = true
	apiPort := int(arguments.(map[interface{}]interface{})["apiPort"].(int32))
	tcpPort := int(arguments.(map[interface{}]interface{})["tcpPort"].(int32))

	if err := os.Setenv("BIND_LOCAL", "true"); err != nil {
		log.DefaultLogger.Fatal("err setting env", log.Error(err))
	}
	if err := os.Setenv("BIND_PRIVATE", "true"); err != nil {
		log.DefaultLogger.Fatal("err setting env", log.Error(err))
	}
	// if err := os.Setenv("LOG_LEVEL", "debug"); err != nil {
	// 	log.DefaultLogger.Fatal("err setting env", log.Error(err))
	// }
	// os.Setenv("DEBUG_BLOCKS", "true")
	os.Setenv("NIMONA_API_HOST", "localhost")

	// os.Setenv("NIMONA_CONFIG", "${HOME}/.io.nimona.mochi-"+strconv.Itoa(apiPort))
	// os.Setenv("NIMONA_API_PORT", strconv)
	// os.Setenv("NIMONA_PEER_TCP_PORT", "10001")

	// os.Setenv("NIMONA_CONFIG", "${HOME}/.io.nimona.mochi-2")
	// os.Setenv("NIMONA_API_PORT", "10802")
	// os.Setenv("NIMONA_PEER_TCP_PORT", "10002")

	ctx := context.New(
		context.WithCorrelationID("nimona"),
	)

	nodeAlias := os.Getenv("NIMONA_ALIAS")
	if nodeAlias != "" {
		log.DefaultLogger = log.DefaultLogger.With(
			log.String("$alias", nodeAlias),
		)
	}

	logger := log.FromContext(ctx).With(
		log.String("build.version", version.Version),
		log.String("build.commit", version.Commit),
		log.String("build.timestamp", version.Date),
	)

	// load config
	logger.Info("loading config file")
	config := config.New()
	config.Path = "${HOME}/.mochi-" + strconv.Itoa(apiPort)
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

	// create identity key pair if it does not exist
	// TODO this is temporary
	if config.Peer.IdentityKey == "" {
		logger.Info("creating new ident	ity key pair")
		identityKey, err := crypto.GenerateEd25519PrivateKey()
		if err != nil {
			logger.Fatal("could not generate identity key", log.Error(err))
		}
		config.Peer.IdentityKey = identityKey
	}

	fmt.Println(">>> PEER PUB", config.Peer.PeerKey.PublicKey())
	fmt.Println(">>> IDENTITY PUB", config.Peer.IdentityKey.PublicKey())

	// update config
	if err := config.Update(); err != nil {
		logger.Fatal("could not update config", log.Error(err))
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
	mochi, _ := mochi.New(store, d)

	// mochi.CreateConversation("foo", "bar")

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

	os, _ := d.Store.Filter(
		sqlobjectstore.FilterByStreamHash(
			object.Hash("hash:oh1.EPFTTgv9kgNm2smeJoxWzJjiixTV51ea21FjKbepXL8G"),
		),
	)

	ddd, _ := dot.Dot(os)
	fmt.Println(ddd)

	go apiServer.Serve(apiAddress) // nolint: errcheck

	time.Sleep(2 * time.Second)

	return nil, nil
}
