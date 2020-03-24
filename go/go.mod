module mochi.io

go 1.14

require (
	github.com/fsnotify/fsnotify v1.4.8 // indirect
	github.com/geoah/go-nimona-notifier v0.0.1
	github.com/go-flutter-desktop/go-flutter v0.36.1
	github.com/go-flutter-desktop/plugins/url_launcher v0.1.2
	github.com/gorilla/websocket v1.4.1
	github.com/jinzhu/gorm v1.9.12
	github.com/miguelpruivo/flutter_file_picker/go v0.0.0-20191218104902-b68ee11c6ac1
	github.com/onsi/ginkgo v1.12.0 // indirect
	github.com/onsi/gomega v1.9.0 // indirect
	github.com/pkg/errors v0.9.1
	github.com/stretchr/testify v1.5.1
	github.com/tjarratt/babble v0.0.0-20191209142150-eecdf8c2339d
	github.com/tsdtsdtsd/identicon v0.3.2
	golang.org/x/crypto v0.0.0-20200302210943-78000ba7a073 // indirect
	golang.org/x/sys v0.0.0-20200302150141-5c8b2ff67527 // indirect
	gopkg.in/fsnotify.v1 v1.4.7
	nimona.io v0.6.0
)

// replace nimona.io => ../../../../nimona.io

replace github.com/miguelpruivo/flutter_file_picker/go => github.com/geoah/flutter_file_picker/go v0.0.0-20200324175203-1e268c804959

// replace github.com/go-flutter-desktop/go-flutter => ../../../geoah/go-flutter
