#!/usr/bin/env bash

# https://github.com/lwouis/alt-tab-macos/blob/08581f50c34faa72921cdd19358712edd85e088a/scripts/update_appcast.sh

set -exu

version="${VERSION}"
date="$(date +'%a, %d %b %Y %H:%M:%S %z')"
minimumSystemVersion=10.11
zipName="$NAME-v${VERSION}.zip"
edSignatureAndLength=$(./macos/Pods/Sparkle/bin/sign_update -s ${SPARKLE_ED_PRIVATE_KEY} "./artifacts/$zipName")

echo "
        <item>
          <title>Version $version</title>
          <pubDate>$date</pubDate>
          <sparkle:minimumSystemVersion>$minimumSystemVersion</sparkle:minimumSystemVersion>
          <sparkle:releaseNotesLink>https://github.com/nimona/flutter-mochi/releases/tag/v$version</sparkle:releaseNotesLink>
          <enclosure url=\"https://github.com/nimona/flutter-mochi/releases/download/v$version/$zipName\" sparkle:version=\"$version\" sparkle:shortVersionString=\"$version\" $edSignatureAndLength type=\"application/octet-stream\"/>
        </item>" > ITEM.txt

sed -i '' -e "/<\/language>/r ITEM.txt" ./artifacts/changelog.xml
