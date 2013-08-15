@version = "1.0.0"

Pod::Spec.new do |s|
  s.name         = "ZXZViewController"
  s.version      = @version
  s.summary      = "Sean Cheng's Development Framework."
  s.homepage     = "https://github.com/remaerd/ZXZViewController"
  s.license      = { :type => 'MIT'}

  s.author       = { "Sean Cheng" => "sean@extremelylimited.com" }
  s.source       = { :git => "https://github.com/remaerd/ZXZViewController.git", :tag => @version }
  
  s.source_files = 'ZXZViewController/**/*.{h,m}'
  
  s.ios.deployment_target = '5.0'
end
