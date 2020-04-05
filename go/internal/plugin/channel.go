package plugin

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/go-flutter/plugin"
	"mochi.io/internal/daemon"
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
	channel.HandleFunc("startDaemon", func(arguments interface{}) (interface{}, error) {
		apiPort := int(arguments.(map[interface{}]interface{})["apiPort"].(int32))
		tcpPort := int(arguments.(map[interface{}]interface{})["tcpPort"].(int32))
		err := daemon.StartDaemon(apiPort, tcpPort)
		return nil, err
	})
	return nil // no error
}
