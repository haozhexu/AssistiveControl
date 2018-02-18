#
#  Be sure to run `pod spec lint AssistiveControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "AssistiveControl"
  s.version      = "1.1"
  s.summary      = "UIControl subclass which mimics the behaviour of iOS Assistive Touch on screen button, fully customisable and extensible."

  s.description  = <<-DESC
  UIControl subclass which mimics the behaviour of iOS AssistiveTouch, fully customisable and extensible.
  When it's added to the main window, it behaves like a universal app-wise floating control with collapsed and expanded states, which enables app-wise tasks such like debugging.
                   DESC

  s.homepage     = "https://github.com/haozhexu/AssistiveControl"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Haozhe XU" => "haozhe.xu3@gmail.com" }
  s.social_media_url   = "http://twitter.com/hzxu"
  s.platform     = :ios, "10.0"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  s.swift_version = "4.0"
  s.source       = { :git => "https://github.com/haozhexu/AssistiveControl.git", :tag => "#{s.version}" }
  s.source_files  = "AssistiveControl", "AssistiveControl/**/*.{swift}"
  s.exclude_files = "Classes/Exclude"
  s.public_header_files = "AssistiveControl/**/*.h"

end
