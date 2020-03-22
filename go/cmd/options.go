package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/plugins/url_launcher"

	"mochi.io/internal/plugin"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(800, 1280),
	flutter.AddPlugin(&url_launcher.UrlLauncherPlugin{}),
	// TODO(geoah) re-enabled settings when dark theme is better defined
	// flutter.AddPlugin(&plugin.SettingsPlugin{}),
	flutter.AddPlugin(&plugin.NimonaDaemon{}),
}
