package plugin

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"

	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/go-flutter/plugin"

	"gopkg.in/fsnotify.v1"
)

var _ flutter.Plugin = (*SettingsPlugin)(nil) // compile-time type check

type (
	// SettingsPlugin is a plugin to interact with the internal flutter setting
	// system. See https://github.com/flutter/engine/blob/master/shell/platform/android/io/flutter/embedding/engine/systemchannels/SettingsChannel.java
	SettingsPlugin struct{}

	// JSON MessageCodec impl has provided by the plugin writer
	settingsJSONMessageCodec struct{}

	// settingsJSONMessage is the structure we send to the platform channel
	settingsJSONMessage struct {
		PlatformBrightness    string  `json:"platformBrightness"`
		AlwaysUse24HourFormat bool    `json:"alwaysUse24HourFormat"`
		TextScaleFactor       float32 `json:"textScaleFactor"`
	}

	provider interface {
		IsDark() bool
		Watch(func(bool)) error
	}

	// windows provider based on https://gist.github.com/jerblack/1d05bbcebb50ad55c312e4d7cf1bc909
	windowsProvider struct{}

	// mac provider based on https://gist.github.com/jerblack/869a303d1a604171bf8f00bbbefa59c2
	macProvider struct{}
)

// EncodeMessage encodes a settingsJSONMessage to a slice of bytes.
func (j settingsJSONMessageCodec) EncodeMessage(message interface{}) (binaryMessage []byte, err error) {
	return json.Marshal(message)
}

// send-only channel
func (j settingsJSONMessageCodec) DecodeMessage(binaryMessage []byte) (message interface{}, err error) {
	return message, err
}

// InitPlugin creates a BasicMessageChannel for "flutter/settings"
func (s *SettingsPlugin) InitPlugin(messenger plugin.BinaryMessenger) error {
	channel := plugin.NewBasicMessageChannel(
		messenger,
		"flutter/settings",
		settingsJSONMessageCodec{},
	)

	var p provider
	switch runtime.GOOS {
	case "windows":
		p = &windowsProvider{}
	case "darwin":
		p = &macProvider{}
	default:
		return fmt.Errorf("platform not supported")
	}

	sendPlatformBrightness := func(isDark bool) {
		platformBrightness := "light"
		if isDark {
			platformBrightness = "dark"
		}
		message := settingsJSONMessage{
			PlatformBrightness:    platformBrightness,
			AlwaysUse24HourFormat: true,
			TextScaleFactor:       1.0,
		}
		err := channel.Send(message)
		if err != nil {
			fmt.Printf("Error sending settings on 'flutter/settings': %v", err)
		}
	}

	sendPlatformBrightness(p.IsDark())
	go p.Watch(sendPlatformBrightness) // nolint: errcheck

	return nil
}

func (p macProvider) IsDark() bool {
	cmd := exec.Command("defaults", "read", "-g", "AppleInterfaceStyle")
	if err := cmd.Run(); err != nil {
		if _, ok := err.(*exec.ExitError); ok {
			return false
		}
	}
	return true
}

func (p macProvider) Watch(fn func(bool)) error {
	const plistPath = `/Library/Preferences/.GlobalPreferences.plist`
	plist := filepath.Join(os.Getenv("HOME"), plistPath)
	wasDark := false

	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		return err
	}
	defer watcher.Close()

	done := make(chan error)
	go func() {
		for {
			select {
			case event, ok := <-watcher.Events:
				if !ok {
					done <- nil
					return
				}
				if event.Op&fsnotify.Create == fsnotify.Create {
					isDark := p.IsDark()
					if isDark && !wasDark {
						fn(isDark)
						wasDark = isDark
					}
					if !isDark && wasDark {
						fn(isDark)
						wasDark = isDark
					}
				}
			case err, ok := <-watcher.Errors:
				if !ok {
					done <- err
					return
				}
			}
		}
	}()

	err = watcher.Add(plist)
	if err != nil {
		return err
	}

	return <-done
}

func (p windowsProvider) IsDark() bool {
	return false
}

func (p windowsProvider) Watch(fn func(bool)) error {
	return fmt.Errorf("not implemented")
}
