Pod::Spec.new do |spec|
spec.name         = 'Conventional'
spec.version      = '1.0.0'
spec.license      = { :type => 'MIT', :file => 'LICENSE.md'}
spec.homepage     = 'https://github.com/VladimirBorodko'
spec.authors      = { 'Vladimir Borodko' => 'vladimirborodko@gmail.com' }
spec.summary      = 'Library to reduce boilerplate and coupling'
spec.source       = { :path => 'Sources/' }
spec.module_name  = 'Conventional'
spec.platform     = :ios, :tvos
spec.ios.deployment_target  = '10.0'
spec.tvos.deployment_target  = '10.0'
spec.source_files       = 'Sources'
spec.framework      = 'SystemConfiguration'
spec.ios.framework  = 'UIKit'
spec.tvos.framework  = 'UIKit'
end
