
Pod::Spec.new do |s|

  # 1
  s.platform = :ios
  s.ios.deployment_target = '12.0'
  s.platform = :ios, '12.0'
  s.name = "LynkiDSDK"
  s.requires_arc = true
  s.summary = "LynkiD SDK"
  
  # 2
  s.version = "0.0.1"
  
  # 3
  s.license = { :type => "MIT", :file => "LICENSE" }
  
  # 4
  s.author = { "ThanhNTH" => "thanhnh.hpvn@gmail.com" }
  
  # 5 
  s.homepage = "https://github.com/hathanhds/lynkid_ios_sdk"
  
  # 6
  s.source = { :git => "https://github.com/hathanhds/lynkid_ios_sdk", 
               :tag => "#{s.version}" }
  
  # 7
  s.framework = "UIKit"
  s.dependency 'RxCocoa', '~> 6.7.1'
  s.dependency 'Moya/RxSwift', '~> 15.0.0'
  s.dependency 'SDWebImage', '~> 5.18.10'
  s.dependency 'iCarousel', '~> 1.8.3'
  s.dependency 'IQKeyboardManagerSwift', '~> 6.5.16'
  s.dependency 'SwiftyAttributes', '~> 5.4.0'
  s.dependency 'Tabman', '~> 3.0'
  s.dependency 'EasyTipView', '~> 2.1.0'
  s.dependency 'SVGKit', '~> 3.0.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  
  # 8
  # s.source_files = "LynkiDSDK/**/*.{swift}"
  s.source_files = "LynkiDSDK/**/*.{swift}"
  
  # 9
  s.resources = "LynkiDSDK/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,ttf,svg,html,xcframework}"
  #s.resources = "LynkiDSDK/**/*"
  
  # 10
  s.swift_version = "4.2"
  
  end
