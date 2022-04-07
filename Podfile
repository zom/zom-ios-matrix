platform :ios, '11'
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git' # Direct access to GitHub as last resort.

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    next unless config.name == 'Debug'
    config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = [
      '$(FRAMEWORK_SEARCH_PATHS)'
    ]
  end
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        config.build_settings['ENABLE_BITCODE'] = 'NO'
      end
    end
end

def shared_pods
    #pod 'KeanuCore', :path => '../../Keanu'
    pod 'KeanuCore', :git => 'https://gitlab.com/keanuapp/keanuapp-ios.git', :commit => '2f67b974'
    #pod 'MatrixKit', :git => 'https://github.com/N-Pex/matrix-ios-kit.git', :branch => 'fix_apns_push'
    #pod 'MatrixSDK', :git => 'https://github.com/matrix-org/matrix-ios-sdk.git', :branch => 'develop'
    #pod 'MatrixSDK', :path => '../../matrix-ios-sdk'
end

target 'Zom 2' do
  shared_pods

  pod 'RichEditorView', :git => 'https://gitlab.com/keanuapp/keanuapp-ios-richeditorview.git', :branch => 'build_fixes'
  pod 'CrossroadRegex', :git => 'https://github.com/crossroadlabs/Regex.git', :tag => '1.2.0'
  pod 'ISEmojiView', :git => 'https://github.com/tladesignz/ISEmojiView.git'
  #pod 'AirShare', :git => 'https://github.com/tladesignz/AirShare.git'
  #pod 'Keanu', :path => '../../Keanu'
  pod 'Keanu', :git => 'https://gitlab.com/keanuapp/keanuapp-ios.git', :commit => '2f67b974'
end

target 'ShareExtension' do
  shared_pods

  #pod 'KeanuExtension', :path => '../../Keanu'
  pod 'KeanuExtension', :git => 'https://gitlab.com/keanuapp/keanuapp-ios.git', :commit => '2f67b974'
end
