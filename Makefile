VERSION = $(shell yq r pubspec.yaml 'version')

CERT_NAME := Developer ID Application: George Antoniadis (LNCQ7FYZE7)
APPLE_USERNAME := george@noodles.gr
APPLE_PASSWORD := @keychain:AC_PASSWORD

.PHONY: build
build:
	echo "Building $(VERSION)"
	@hover build darwin-bundle
	@codesign \
		-s "$(CERT_NAME)" \
		-fv \
		--entitlements entitlements.xml \
		--deep \
		--options runtime \
		--timestamp \
		./go/build/outputs/darwin-bundle/mochi-$(VERSION).app
	@rm ./artifacts/mochi-$(VERSION).app.zip
	@ditto \
		-c \
		-k \
		--keepParent \
		./go/build/outputs/darwin-bundle/mochi-$(VERSION).app \
		./artifacts/mochi-$(VERSION).app.zip
	@xcrun altool \
		--notarize-app \
		--primary-bundle-id "io.nimona.mochi" \
		--username "$(APPLE_USERNAME)" \
		--password "$(APPLE_PASSWORD)" \
		--file ./artifacts/mochi-$(VERSION).app.zip

.PHONE: build-verify
build-verify:
	@xcrun altool \
		--username "$(APPLE_USERNAME)" \
		--password "$(APPLE_PASSWORD)" \
		--notarization-info $(REQ_ID)