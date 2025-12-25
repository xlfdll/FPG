#!/bin/bash

pushd ../src

rm -rf build
flutter pub get
flutter build linux --release

mkdir -p ./build/linux/x64/release/bundle/res
cp -v ./linux/resources/app_icon.ico ./build/linux/x64/release/bundle/res

popd
