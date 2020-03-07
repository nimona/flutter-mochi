package plugin

import (
	"encoding/json"
	"fmt"

	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/go-flutter/plugin"
)

// SettingsPlugin is a plugin to interact with the internal flutter setting
// system. See https://github.com/flutter/engine/blob/master/shell/platform/android/io/flutter/embedding/engine/systemchannels/SettingsChannel.java
type SettingsPlugin struct{}

var _ flutter.Plugin = &SettingsPlugin{} // compile-time type check

type settingsJSONMessageCodec struct{} // JSON MessageCodec impl has provided by the plugin writer

// EncodeMessage encodes a settingsJSONMessage to a slice of bytes.
func (j settingsJSONMessageCodec) EncodeMessage(message interface{}) (binaryMessage []byte, err error) {
	mm, err := json.Marshal(message)
	fmt.Println(string(mm))
	return mm, err
}

// send-only channel
func (j settingsJSONMessageCodec) DecodeMessage(binaryMessage []byte) (message interface{}, err error) {
	return message, err
}

type settingsJSONMessage struct {
	PlatformBrightness    string `json:"platformBrightness"`
	TextScaleFactor       string `json:"textScaleFactor"`
	AlwaysUse24HourFormat string `json:"alwaysUse24HourFormat"`
}

// InitPlugin creates a BasicMessageChannel for "flutter/settings"
func (p *SettingsPlugin) InitPlugin(messenger plugin.BinaryMessenger) error {
	channel := plugin.NewBasicMessageChannel(messenger, "flutter/settings", settingsJSONMessageCodec{})

	message := settingsJSONMessage{
		PlatformBrightness:    "dark",
		TextScaleFactor:       "1",
		AlwaysUse24HourFormat: "true",
	}
	print("\n --> Sending platformBrightness: dark\n")
	ok := channel.Send(message)
	fmt.Printf("\nRes: %v\n", ok == nil)
	return nil
}
