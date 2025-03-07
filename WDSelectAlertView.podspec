#
# Be sure to run `pod lib lint WDSelectAlertView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WDSelectAlertView'
  s.version          = '0.1.12'
  s.summary          = 'WDSelectAlertView is a customizable pop-up tool.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
WDSelectAlertView is a customizable pop-up tool. 
It can be used to replace the components of the system.
I wrote it for learning purposes, and I hope you can provide valuable comments.
                       DESC

  s.homepage         = 'https://github.com/jocelen/WDSelectAlertView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jocelen' => 'jocelen@163.com' }
  s.source           = { :git => 'https://github.com/jocelen/WDSelectAlertView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'WDSelectAlertView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WDSelectAlertView' => ['WDSelectAlertView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
