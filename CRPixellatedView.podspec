Pod::Spec.new do |spec|
  spec.name         = 'CRGradientLabel'
  spec.version      = '1.0.2'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage     = 'https://github.com/chroman/CRGradientLabel'
  spec.author       =  { 'Christian Roman' => 'chroman16@gmail.com' }
  spec.summary      = 'Custom UILabel subclass with gradient coloured backgrounds.'
  spec.source       =  { :git => 'https://github.com/chroman/CRGradientLabel.git', :tag => "#{spec.version}" }
  spec.source_files = 'CRGradientLabel/Swift/*.swift'
  spec.framework    = 'Foundation'
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/chroman'
  spec.ios.deployment_target = '7.0'
end
