# RCBacktrace

![badge-pms](https://img.shields.io/badge/languages-Swift|ObjC-orange.svg)
![badge-platforms](https://img.shields.io/cocoapods/p/RCBacktrace.svg?style=flat)
![badge-languages](https://img.shields.io/badge/supports-Carthage|CocoaPods|SwiftPM-green.svg)
[![Swift Version](https://img.shields.io/badge/Swift-4.0--5.0.x-F16D39.svg?style=flat)](https://developer.apple.com/swift)

Getting backtrace of any thread for Objective-C and Swift. Only a small amount of C code, almost all done in Swift. 
It is is much more powerful than Thread.callStackSymbols, callStackSymbols can only get the current thread call stack symbol, and the symbol not Name Mangling in Swift。

## Features

- [x] Support both Objective-C and Swift
- [x] Support get backtrace of any thread
- [x] Support swift_demangle


## Usage

### setup

```
RCBacktrace.setup()

```

### callstack of thead

```
let symbols = RCBacktrace.callstack(.main)
for symbol in symbols {
    print(symbol.description)
}

```

![Screen Shot 2019-08-27 at 10.40.02 PM.png](https://upload-images.jianshu.io/upload_images/2086987-01248172e2c933e8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



≈ Requirements

- iOS 8.0+
- Swift 4.0-5.x


## Installation

#### Carthage
Add the following line to your [Cartfile](https://github.com/carthage/carthage)

```
git "https://github.com/woshiccm/RCBacktrace.git" "0.1.6"
```

### CocoaPods
[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. To integrate Aspect into your Xcode project using CocoaPods, specify it in your `Podfile`:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'xxxx' do
    pod 'RCBacktrace', '~> 0.1.6'
end

```

## License

Aspect is released under the MIT license. See LICENSE for details.
