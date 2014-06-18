Pod::Spec.new do |spec|
  spec.name         = 'CRPixellatedView'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage     = 'https://github.com/chroman/CRPixellatedView'
  spec.author       =  { 'Christian Roman' => 'chroman16@gmail.com' }
  spec.summary      = 'Custom UIView subclass with a cool pixellated animation inspired by Facebook's Slingshot app.'
  spec.source       =  { :git => 'https://github.com/chroman/CRPixellatedView.git', :tag => "#{spec.version}" }
  spec.source_files = 'CRPixellatedView/*.{h,m}'
  spec.frameworks   = 'UIKit', 'QuartzCore'
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/chroman'
  spec.ios.deployment_target = '6.0'
end
