package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/plugins/url_launcher"
	file_picker "github.com/miguelpruivo/flutter_file_picker/go"

	"mochi.io/internal/plugin"
)

var options = []flutter.Option{
	flutter.AddPlugin(&plugin.FocusCallback{}),
	flutter.WindowInitialDimensions(800, 1280),
	flutter.AddPlugin(&file_picker.FilePickerPlugin{}),
	flutter.AddPlugin(&url_launcher.UrlLauncherPlugin{}),
	// TODO(geoah) re-enabled settings when dark theme is better defined
	// flutter.AddPlugin(&plugin.SettingsPlugin{}),
	flutter.AddPlugin(&plugin.NimonaDaemon{}),
}
