[![Build Status](https://travis-ci.org/Sega-Zero/SZAutogrowTextView.svg)](https://travis-ci.org/Sega-Zero/SZAutogrowTextView)
[![Pod Version](https://img.shields.io/cocoapods/v/SZAutogrowTextView.svg?style=flat)](http://cocoadocs.org/docsets/SZAutogrowTextView/)
[![Pod Platform](http://img.shields.io/cocoapods/p/SZAutogrowTextView.svg?style=flat)](http://cocoadocs.org/docsets/SZAutogrowTextView/)
[![Pod License](http://img.shields.io/cocoapods/l/SZAutogrowTextView.svg?style=flat)](http://opensource.org/licenses/MIT)

# SZAutogrowTextView
Yet another autogrow UITextView subclass. No extra work required. No extra constraints needed. Autolayout compatible. It just works.

#Installation

##CocoaPods
This class is available via [CocoaPods](http://cocoapods.org/). Write this in your `Podfile`:

```
pod 'SZAutogrowTextView'
```
Then run `pod install` or `pod update`

##Manual

Simply clone this repo and copy `SZAutogrowTextView.h` and `SZAutogrowTextView.m` to your project.

# Usage

Assign your textview's class to `SZAutogrowTextView` in IB. Set the minimum and maximum constraints you need. Set `animateHeightChange` to `NO` if you don't want it's height to animate on text change.
See example project to see it's working.
