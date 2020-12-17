#!/bin/sh

flutter pub get
cd ios
pod install
cd ..
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release -destination generic/platform=iOS build
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release -sdk iphoneos archive -archivePath $PWD/build/FPG.xcarchive
xcodebuild -exportArchive -archivePath $PWD/build/FPG.xcarchive -exportOptionsPlist exportOptions.plist -exportPath $PWD/build