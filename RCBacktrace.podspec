Pod::Spec.new do |spec|
  spec.name = 'RCBacktrace'
  spec.version = '0.1.7'
  spec.license = 'MIT'
  spec.summary = 'Getting backtrace of any thread for Objective-C and Swift'
  spec.homepage = 'https://github.com/woshiccm/RCBacktrace'
  spec.author = "roy"
  spec.source    = { :git => "https://github.com/woshiccm/RCBacktrace.git", :tag => spec.version }
  spec.license = 'Code is private.'

  spec.platforms = { :ios => '8.0' }
  spec.requires_arc = true

  spec.cocoapods_version = '>= 1.4'
  spec.swift_version = ['4.2', '5.0']

  spec.source_files = 'RCBacktrace/**/*.{h,c,swift}'
end
