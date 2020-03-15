# Mochi

## Development

The websocket datastore you will to run it using `hover`.
For this you'll need a couple of things.

* xcode, git
* golang (v1.14)
* [flutter](https://flutter.dev/docs/get-started/install/macos) (beta channel)
* [hover](https://github.com/go-flutter-desktop/hover)

```sh
git clone git@github.com:nimona/flutter-mochi.git
cd flutter-mochi
flutter channel beta
flutter upgrade
flutter doctor
```

```sh
LOG_LEVEL=debug UPNP=true hover run
```
