Pod::Spec.new do |s|

  s.name         = "HMYAssistiveControl"
  s.version      = "0.0.2"
  s.summary      = "A UIControl subclass that mimics the behaviour of iOS Assistive Touch."

  s.description  = <<-DESC
		   HMYAssistiveControl is a mimic of iOS Assistive Touch,
		   it allows you to specify a custom collapsed view and expanded view.
		   It handles all the touch / drag behaviours the same as Assistive Touch
                   DESC

  s.homepage     = "https://github.com/haozhexu/HMYAssistiveControl"
  s.license      = 'MIT'
  s.author       = { "HAOZHE XU" => "haozhe.xu3@gmail.com" }
  s.platform     = :ios, '6.0'

  s.ios.deployment_target = '6.0'

  s.source       = { :git => "https://github.com/haozhexu/HMYAssistiveControl.git", :tag => "0.0.2" }
  s.source_files  = 'HMYAssistiveControl/Classes', 'HMYAssistiveControl/Classes/**/*.{h,m}'
end
