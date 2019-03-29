platform :ios, '9.1'
use_frameworks!

def shared_pods
    pod 'KeanuCore', :path => '../../Keanu'
end

target 'Zom 2' do
  shared_pods

  pod 'BarcodeScanner', :git => 'https://github.com/SteffanPB/BarcodeScanner.git'

  pod 'Keanu', :path => '../../Keanu'

end

target 'ShareExtension' do
  shared_pods

  pod 'KeanuExtension', :path => '../../Keanu'
end
