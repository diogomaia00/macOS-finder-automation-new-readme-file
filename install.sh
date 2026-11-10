#!/bin/bash
# Build, sign with the personal Apple Development identity, install to ~/Applications and enable the extension.
set -euo pipefail
cd "$(dirname "$0")"
IDENTITY="${IDENTITY:-Apple Development: diogomaia09@gmail.com}"
xcodegen generate --quiet
xcodebuild -project NewReadme.xcodeproj -scheme NewReadme -configuration Release -derivedDataPath build -quiet build
APP=build/Build/Products/Release/NewReadme.app
codesign --force --options runtime --sign "$IDENTITY" --entitlements Extension/FinderSync.entitlements "$APP/Contents/PlugIns/NewReadmeFinderSync.appex"
codesign --force --options runtime --sign "$IDENTITY" --entitlements App/App.entitlements "$APP"
mkdir -p ~/Applications
rm -rf ~/Applications/NewReadme.app
cp -R "$APP" ~/Applications/
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f -R ~/Applications/NewReadme.app
open ~/Applications/NewReadme.app
sleep 2
pluginkit -a ~/Applications/NewReadme.app/Contents/PlugIns/NewReadmeFinderSync.appex
pluginkit -e use -i pt.diogomaia.NewReadme.FinderSync
killall Finder
pluginkit -m -v -i pt.diogomaia.NewReadme.FinderSync
