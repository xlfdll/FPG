#!/bin/sh

flutter pub get
cd ios
pod install
xcodebuild -xcconfig ../build.xcconfig -workspace Runner.xcworkspace -scheme Runner -configuration Release -destination generic/platform=iOS build
xcodebuild -xcconfig ../build.xcconfig -workspace Runner.xcworkspace -scheme Runner -configuration Release -sdk iphoneos archive -archivePath ../build/FPG.xcarchive
xcodebuild -xcconfig ../build.xcconfig -exportArchive -archivePath ../build/FPG.xcarchive -exportOptionsPlist exportOptions.plist -exportPath ../build