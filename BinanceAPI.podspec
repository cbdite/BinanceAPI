Pod::Spec.new do |s|
  s.name     = 'BinanceAPI'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'An Objective-C based implementation of the Binance API for iOS and macOS.'
  s.homepage = 'https://github.com/cbdite/BinanceAPI'
  s.author  = 'Chris Dite'
  s.source   = { :git => 'https://github.com/cbdite/BinanceAPI.git', :tag => s.version }
  s.requires_arc = true
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.13'
  s.source_files = 'Classes/**/*.{h,m}'
  s.frameworks = 'Security'
  s.dependency 'AFNetworking', '3.1.0'
  s.dependency 'AFNetworking-Synchronous/3.x', '1.1.0'
  s.dependency 'CocoaLumberjack', '3.3.0'
  s.dependency 'PocketSocket', '1.0.1'
end
