platform :ios, '9.3'
use_frameworks!

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    next unless config.name == 'Debug'
    config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = [
      '$(FRAMEWORK_SEARCH_PATHS)'
    ]
  end
end

def shared_pods
    #pod 'KeanuCore', :path => '../../Keanu'
    pod 'KeanuCore', :git => 'https://gitlab.com/keanuapp/keanuapp-ios.git', :commit => '858e3a2d'
    #pod 'MatrixKit', :git => 'https://github.com/N-Pex/matrix-ios-kit.git', :branch => 'fix_apns_push'
    #pod 'MatrixSDK', :git => 'https://github.com/matrix-org/matrix-ios-sdk.git', :branch => 'develop'
end

target 'Zom 2' do
  shared_pods

  pod 'RichEditorView', :git => 'https://gitlab.com/keanuapp/keanuapp-ios-richeditorview.git', :branch => 'build_fixes'
  pod 'CrossroadRegex', :git => 'https://github.com/crossroadlabs/Regex.git', :tag => '1.2.0'
  pod 'AirShare', :git => 'https://github.com/tladesignz/AirShare.git'

  #pod 'Keanu', :path => '../../Keanu'
  pod 'Keanu', :git => 'https://gitlab.com/keanuapp/keanuapp-ios.git', :commit => '858e3a2d'
end

target 'ShareExtension' do
  shared_pods

  #pod 'KeanuExtension', :path => '../../Keanu'
  pod 'KeanuExtension', :git => 'https://gitlab.com/keanuapp/keanuapp-ios.git', :commit => '858e3a2d'
end
