workspace 'PMPlatform_IOS.xcworkspace'
project 'PMPlatform_IOS.xcodeproj'

# Pods for ycxm
target 'PMPlatform_IOS' do
    source 'https://github.com/CocoaPods/Specs.git'
    platform :ios, '9.0'
    use_frameworks!
    pod 'MJRefresh'
    pod 'MJExtension'
    pod 'PPBadgeView'
    pod 'SVProgressHUD'
    pod 'Charts'
    pod 'Masonry', '~> 1.1.0'
    pod 'RATreeView', '~> 2.1.2'
    pod 'SDWebImage', '5.18.2'
    pod 'YTKNetwork'
    pod 'AFViewShaker', '~> 0.0.4'
    pod 'CocoaLumberjack', '~> 3.3.0'
    pod 'SDCycleScrollView', '~> 1.75'
    pod 'IQKeyboardManager', '6.5.11'
    pod 'TZImagePickerController', '~> 3.0'
    pod 'GrowingTextView', '~> 0.6.1'
    pod 'AMapLocation-NO-IDFA' #无IDFA版定位 SDK
    pod 'AMap3DMap-NO-IDFA' #2D地图SDK
    
    pod 'Moya'
    pod 'SwiftyJSON'
    pod 'ESTabBarController-swift'
    pod 'LLCycleScrollView'
    pod 'GYSide'
    pod 'LYEmptyView'
    pod 'LMReport'
    pod 'MBProgressHUD', :git => 'https://github.com/jdg/MBProgressHUD.git', :commit => '18c442d57398cee5ef57f852df10fc5ff65f0763'
    
    pod 'YYKit', '1.0.9'
    pod 'LEEAlert', '1.4.2'
    pod 'ReactiveObjC', '3.1.1'
    pod 'SSZipArchive', '2.2.2'
    pod 'TXIMSDK_Smart_iOS', '5.1.138'
    pod 'AFNetworking', '4.0.1'
    pod 'lottie-ios', '2.5.3'
    pod 'SlideMenuControllerOC'
end


pre_install do |installer|
    def installer.verify_no_static_framework_transitive_dependencies; end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
            # 修复 Xcode 26 移除 libarclite 导致的编译错误
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 12.0
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
            end
            # 修复老库在 Xcode 26 下的编译错误
            config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
            config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
            config.build_settings['GCC_TREAT_WARNINGS_AS_ERRORS'] = 'NO'
            config.build_settings['SWIFT_TREAT_WARNINGS_AS_ERRORS'] = 'NO'
            config.build_settings['CLANG_WARN_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'NO'
            config.build_settings['OTHER_CFLAGS'] = ['$(inherited)', '-Wno-error', '-w',
                '-Wno-error=non-modular-include-in-framework-module',
                '-Wno-error=deprecated-objc-isa-usage',
                '-Wno-error=implicit-function-declaration',
                '-Wno-error=return-type',
                '-Wno-error=objc-root-class']
            # 移除 YYKit 对旧版 WebP.framework 的链接依赖
            if target.name == 'YYKit'
                config.build_settings['OTHER_LDFLAGS'] = ['$(inherited)']
                frameworks = config.build_settings['FRAMEWORK_SEARCH_PATHS'] || ['$(inherited)']
                frameworks = [frameworks] if frameworks.is_a?(String)
                frameworks.reject! { |f| f.include?('Vendor') }
                config.build_settings['FRAMEWORK_SEARCH_PATHS'] = frameworks
            end
        end
    end
end
#unable UUID
install! 'cocoapods',
         :deterministic_uuids => false

