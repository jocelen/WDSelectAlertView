Pod::Spec.new do |s|
  s.name             = 'WDSelectAlertView'
  s.version          = '0.2.0'
  s.summary          = 'WDSelectAlertView is a customizable pop-up component adapted for iOS 15 - iOS 26 Liquid Glass.'

  s.description      = <<-DESC
WDSelectAlertView is a customizable alert, action sheet, date picker, time interval picker, and key-value picker component.
Supports iOS 15.0+ and native iOS 26 Liquid Glass (UIGlassEffect), Dark Mode, UIScene windowing, CocoaPods, and Swift Package Manager.
                       DESC

  s.homepage         = 'https://github.com/jocelen/WDSelectAlertView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jocelen' => 'jocelen@163.com' }
  s.source           = { :git => 'https://github.com/jocelen/WDSelectAlertView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'

  s.source_files = 'WDSelectAlertView/Classes/**/*.{h,m}'
  s.public_header_files = 'WDSelectAlertView/Classes/include/*.h'
  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'
end
