NAME = $(shell yq e '.name' pubspec.yaml)
VERSION = $(shell yq e '.version' pubspec.yaml)

CERT_NAME := Developer ID Application: 0x2A Ltd (LNCQ7FYZE7)

APP_PATH := $(CURDIR)

.PHONY: bump-patch
bump-patch: bump-patch-podspec
	$(eval VERSION := $(shell yq e '.version' pubspec.yaml))
	cd ios && \
		fastlane run increment_build_number && \
		agvtool new-marketing-version $(VERSION)
	cd macos && \
		fastlane run increment_build_number && \
		agvtool new-marketing-version $(VERSION)

.PHONY: bump-patch-podspec
bump-patch-podspec:
	pubumgo patch

.PHONY: bump-minor
bump-minor: bump-minor-podspec
	$(eval VERSION := $(shell yq e '.version' pubspec.yaml))
	cd ios && \
		fastlane run increment_build_number && \
		agvtool new-marketing-version $(VERSION)

.PHONY: bump-minor-podspec
bump-minor-podspec:
	pubumgo minor

.PHONY: bump-major
bump-major: bump-major-podspec
	$(eval VERSION := $(shell yq e '.version' pubspec.yaml))
	cd ios && \
		fastlane run increment_build_number && \
		agvtool new-marketing-version $(VERSION)

.PHONY: bump-major-podspec
bump-major-podspec:
	pubumgo major

.PHONY: build-ios
build-ios:
	@echo "Building..."
	@flutter build ios --release --no-codesign
	@echo "All done!"

.PHONY: release-ios
release-ios:
	@echo "Building..."
	@flutter build ios --release --no-codesign
	@cd ios; fastlane beta
	@echo "All done!"

.PHONY: build-macos
build-macos:
	@echo "Building $(VERSION)..."
	@flutter build macos --release

.PHONY: release-macos
release-macos: notarize-macos release-macos-update-appcast

.PHONY: notarize-macos
notarize-macos:
	@echo "Signing..."
	@codesign \
		-s "$(CERT_NAME)" \
		-fv \
		--force \
		--deep \
		--entitlements ./macos/Runner/Release.entitlements \
		--options runtime \
		--timestamp \
		./build/macos/Build/Products/Release/Mochi.app/Contents/Frameworks/Sparkle.framework/Resources/Autoupdate.app
	@codesign \
		-s "$(CERT_NAME)" \
		-fv \
		--force \
		--deep \
		--entitlements ./macos/Runner/Release.entitlements \
		--options runtime \
		--timestamp \
		./build/macos/Build/Products/Release/Mochi.app
	@echo "Zipping..."
	@rm -f ./artifacts/$(NAME)-v$(VERSION).zip
	@ditto \
		-c \
		-k \
		--rsrc \
		--sequesterRsrc \
		--keepParent \
		./build/macos/Build/Products/Release/Mochi.app \
		./artifacts/$(NAME)-v$(VERSION).zip
	@echo "Notarizing..."
	@xcrun altool \
		--notarize-app \
		--primary-bundle-id "io.nimona.$(NAME)" \
		--username "$(APPLE_USERNAME)" \
		--password "$(APPLE_PASSWORD)" \
		--file ./artifacts/$(NAME)-v$(VERSION).zip
	@echo "All done!"

.PHONY: release-macos-update-appcast
release-macos-update-appcast:
	NAME=$(NAME) \
	VERSION=$(VERSION) \
		./update_appcast.sh

.PHONY: notirization-verify
notirization-verify:
	@xcrun altool \
		--username "$(APPLE_USERNAME)" \
		--password "$(APPLE_PASSWORD)" \
		--notarization-info $(REQ_ID)