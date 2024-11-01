# Uncomment the next line to define a global platform for your project

platform :ios, '12.0'

use_frameworks!

target 'LynkiDSDK' do
  # Comment the next line if you don't want to use dynamic frameworks
  pod 'SVProgressHUD', :modular_headers => true
  pod 'RxCocoa'
  pod 'Moya/RxSwift'
  pod 'SDWebImage', '~> 5.18.10', :modular_headers => true
  pod 'iCarousel', '~> 1.8.3', :modular_headers => true
  pod 'SkeletonView'
  pod 'IQKeyboardManagerSwift'
  pod 'SwiftyAttributes'
  pod 'Tabman', '~> 3.0', :modular_headers => true
  pod 'EasyTipView'
  pod 'SVGKit', :modular_headers => true
  
  #inherit! :search_paths
  
  post_install do |installer|
      installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
              end
          end
      end
  end
  
end
