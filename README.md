# HomeGesture
Enable iPhone X home gesture on other iOS 11 devices.

## Features
* iPhone X home and multitasking gestures
* Home Bar, carrier text, breadcrumb, unlock and notification hints hidden
* Uses original button gestures for screenshot and Siri
* Force-close apps without long-pressing in Multitasking

## Building
[Theos](https://github.com/theos/theos) required.

Build tweak using `make` in the source directory.

Tweak binary is located in `./.theos/obj/debug/HomeGesture.dylib`.

## Installing
Copy the tweak binary as well as `HomeGesture.plist` in the source directory to the tweak directory on the iOS device 
(`/bootstrap/Library/SBinject` for Electra on iOS 11.1-11.1.2 or `/Library/TweakInject` for Electra on iOS 11.2-11.3.1).

Prebuilt releases are available [here](https://github.com/VitaTaf/HomeGesture/releases).