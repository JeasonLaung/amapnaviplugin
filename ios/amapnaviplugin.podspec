#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint amapnaviplugin.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'amapnaviplugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'


 s.dependency 'AMapNavi'
 # s.dependency 'AMapNavi-NO-IDFA','7.4.0'
 # s.dependency 'AMapNavi-NO-IDFA','6.9.0'
 s.dependency 'AMapLocation'
 s.dependency 'AMapSearch'
  s.dependency 'HandyJSON','5.0.1'
  
  s.static_framework = true
  s.ios.deployment_target = '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
