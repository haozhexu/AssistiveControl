Pod::Spec.new do |s|

  s.name         = "HUXAssistiveControl"
  s.version      = "0.0.1"
  s.summary      = "A UIControl subclass that mimics the behaviour of iOS Assistive Touch."

  s.description  = <<-DESC
		   HUXAssistiveControl is a mimic of iOS Assistive Touch,
		   it allows you to specify a custom collapsed view and expanded view.
		   It handles all the touch / drag behaviours the same as Assistive Touch
                   DESC

  s.homepage     = "http://www.guistudio.net/github/HUXAssistiveControl/index.html"
  s.license      = 'MIT'
  s.author       = { "HAOZHE XU" => "hao@guistudio.net" }
  s.platform     = :ios, '6.0'

  s.ios.deployment_target = '6.0'

  s.source       = { :git => "https://github.com/haozhexu/HUXAssistiveControl.git", :tag => "0.0.1" }
  s.source_files  = 'HUXAssistiveControl/Classes', 'HUXAssistiveControl/Classes/**/*.{h,m}'
end
