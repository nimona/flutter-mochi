# mochi

Proof of concept messaging application based on nimona.

Currently macos only.

## Building and releasing

* Required tools
  * Git
  * [Flutter](https://flutter.dev/)
  * [Hub](https://github.com/github/hub)
  * [Xcode](https://developer.apple.com/xcode/)
* Required env vars
  * `SPARKLE_ED_PRIVATE_KEY`
* Bump version
  * `make bump-patch`
  * `make bump-minor`
  * `make bump-major`
* Build
  * `make build-ios`
  * `make build-macos`
* Release
  * `make release-ios`
  * `make release-macos`
* Commit, tag, push
* Create release, upload artifacts
