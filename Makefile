NAME = $(shell yq e '.name' pubspec.yaml)
VERSION = $(shell yq e '.version' pubspec.yaml)

APP_PATH := $(CURDIR)
CERT_NAME := Developer ID Application: 0x2A Ltd (LNCQ7FYZE7)
EXPORT_PATH := $(CURDIR)/.submissions
UPLOAD_INFO_PLIST := $(EXPORT_PATH)/UploadInfo.plist
REQUEST_INFO_PLIST := $(EXPORT_PATH)/RequestInfo.plist
AUDIT_INFO_JSON := $(EXPORT_PATH)/AuditInfo.json

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

define notify
	@ /usr/bin/osascript -e 'display notification $2 with title $1'
endef

define wait_while_in_progress
	while true; do \
		/usr/bin/xcrun altool --notarization-info `/usr/libexec/PlistBuddy -c "Print :notarization-upload:RequestUUID" $(UPLOAD_INFO_PLIST)` -u $(APPLE_USERNAME) -p $(APPLE_PASSWORD) --output-format xml > $(REQUEST_INFO_PLIST) ;\
		if [ "`/usr/libexec/PlistBuddy -c "Print :notarization-info:Status" $(REQUEST_INFO_PLIST)`" != "in progress" ]; then \
			break ;\
		fi ;\
		/usr/bin/osascript -e 'display notification "Zzz..." with title "Notarization"' ;\
		sleep 10 ;\
	done
endef

.PHONY: notarize-macos
notarize-macos:
	@echo "Signing..."
	@codesign \
		-s "$(CERT_NAME)" \
		-fv \
		--verbose \
		--force \
		--deep \
		--options runtime \
		--timestamp \
		./build/macos/Build/Products/Release/Mochi.app/Contents/Frameworks/Sparkle.framework/Resources/Autoupdate.app/Contents/MacOS/Autoupdate
	@codesign \
		-s "$(CERT_NAME)" \
		-fv \
		--verbose \
		--force \
		--deep \
		--options runtime \
		--timestamp \
		./build/macos/Build/Products/Release/Mochi.app/Contents/Frameworks/Sparkle.framework/Resources/Autoupdate.app/Contents/MacOS/fileop
	@codesign \
		-s "$(CERT_NAME)" \
		-fv \
		--verbose \
		--force \
		--deep \
		--options runtime \
		--timestamp \
		./build/macos/Build/Products/Release/Mochi.app/Contents/Frameworks/Sparkle.framework/Resources/Autoupdate.app
	@codesign \
		-s "$(CERT_NAME)" \
		-fv \
		--verbose \
		--deep \
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
		--file ./artifacts/$(NAME)-v$(VERSION).zip \
		--output-format xml > $(UPLOAD_INFO_PLIST)
	@sleep 2
	@$(call notify, "Notarization", "Waiting while notarized...")
	@/usr/bin/xcrun altool \
		--notarization-info `/usr/libexec/PlistBuddy \
		-c "Print :notarization-upload:RequestUUID" $(UPLOAD_INFO_PLIST)` \
		-u $(APPLE_USERNAME) \
		-p $(APPLE_PASSWORD) \
		--output-format xml > $(REQUEST_INFO_PLIST)
	$(call wait_while_in_progress)
	@$(call notify, "Notarization", "Downloading log file...")
	@/usr/bin/curl \
		-o $(AUDIT_INFO_JSON) \
		`/usr/libexec/PlistBuddy -c "Print :notarization-info:LogFileURL" $(REQUEST_INFO_PLIST)`
	if [ `/usr/libexec/PlistBuddy -c "Print :notarization-info:Status" $(REQUEST_INFO_PLIST)` != "success" ]; then \
		false; \
	fi
	$(call notify, "Notarization", "✅ Done!")

.PHONY: release-macos-update-appcast
release-macos-update-appcast:
	NAME=$(NAME) \
	VERSION=$(VERSION) \
		./update_appcast.sh

.PHONY: github-release
github-release:
	@git commit -am 'chore: bump to v$(VERSION)'
	@git tag -a v$(VERSION) -m ''
	@git push origin
	@git push origin v$(VERSION)
	@hub release create v$(VERSION) -m 'v$(VERSION)' -a ./artifacts/$(NAME)-v$(VERSION).zip

.PHONY: notirization-verify
notirization-verify:
	@xcrun altool \
		--username "$(APPLE_USERNAME)" \
		--password "$(APPLE_PASSWORD)" \
		--notarization-info $(REQ_ID)