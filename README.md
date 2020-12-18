# Fkulc's Password Generator - Mobile Version
A mobile implementation of [Fkulc's Password Generator (FPG)](https://github.com/xlfdll/FPG)

<a href="https://play.google.com/store/apps/details?id=org.xlfdll.nb.fpg">
  <img src="https://github.com/xlfdll/xlfdll.github.io/raw/master/images/google-play-badge.png" alt="Get Fkulc's Password Generator (Android) on Google Play Store" height="64">
</a>

## Screenshots

### Android

<p align="center">
  <img src="https://github.com/xlfdll/xlfdll.github.io/raw/master/images/projects/FPG/Mobile/FPGMobile-Android-Password.png"
       alt="Fkulc's Password Generator (Android) - Password Screen" height="320"> <img src="https://github.com/xlfdll/xlfdll.github.io/raw/master/images/projects/FPG/Mobile/FPGMobile-Android-Options.png"
       alt="Fkulc's Password Generator (Android) - Options Screen" height="320"> <img src="https://github.com/xlfdll/xlfdll.github.io/raw/master/images/projects/FPG/Mobile/FPGMobile-Android-EditRandomSalt.png"
       alt="Fkulc's Password Generator (Android) - Edit Random Salt Alert Dialog" height="320">
</p>

### iOS

<p align="center">
  <img src="https://github.com/xlfdll/xlfdll.github.io/raw/master/images/projects/FPG/Mobile/FPGMobile-iOS-Password.png"
       alt="Fkulc's Password Generator (Android) - Password Screen" height="320"> <img src="https://github.com/xlfdll/xlfdll.github.io/raw/master/images/projects/FPG/Mobile/FPGMobile-iOS-Options.png"
       alt="Fkulc's Password Generator (Android) - Options Screen" height="320"> <img src="https://github.com/xlfdll/xlfdll.github.io/raw/master/images/projects/FPG/Mobile/FPGMobile-iOS-EditRandomSalt.png"
       alt="Fkulc's Password Generator (Android) - Edit Random Salt Alert Dialog" height="320">
</p>

## System Requirements
Requires at least Android 4.1 (untested). Android 6.0 or later is highly recommended.

## Usage
The usage of this app is same to the original FPG application.

The backup file **FPG_CriticalSettings.dat** generated by other versions of FPG can be transferred to the device and restored in app as follows:

* **Android**: Connect device to a computer (using File Transfer mode), then copy generated **FPG_CriticalSettings.dat** file into **/Android/data/org.xlfdll.nb.fpg/files**
  * macOS users can use the official [Android File Transfer](https://www.android.com/filetransfer/) app to do so
* **iOS**: Use iTunes App File Sharing to transfer **FPG_CriticalSettings.dat** file

## Development Prerequisites
The latest version of the following:
* [Flutter](https://flutter.dev/docs/get-started/install)
* **For Android version:** Android SDK ([Android Studio](https://developer.android.com/studio) with Flutter plugin is highly recommended)
* **For iOS version:** Xcode with command-line tools

## References
An extended version of the architecture description can be found [here](https://github.com/xlfdll/FPG/blob/master/Docs/A%20Hash-Based%20Password%20Management%20System.pdf).
