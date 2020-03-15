package main

import (
	"github.com/go-flutter-desktop/go-flutter"

	"mochi.io/internal/plugin"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(800, 1280),
	// TODO(geoah) re-enabled settings when dark theme is better defined
	// flutter.AddPlugin(&plugin.SettingsPlugin{}),
	flutter.AddPlugin(&plugin.NimonaDaemon{}),
}
