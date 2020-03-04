package main

import (
	"github.com/go-flutter-desktop/go-flutter"

	"mochi.io/internal/plugin"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(800, 1280),
	flutter.AddPlugin(&plugin.NimonaDaemon{}),
}
