platform :ios, '9.3'
use_frameworks!

def shared_pods
    pod 'Localize', :git => 'https://github.com/andresilvagomez/Localize.git'
    pod 'KeanuCore', :path => '../../Keanu'
end

target 'Zom 2' do
  shared_pods

  pod 'BarcodeScanner', :git => 'https://github.com/htothee/BarcodeScanner.git'
  pod 'QRCode', :git => 'https://github.com/brackendev/QRCode.git'

  pod 'Keanu', :path => '../../Keanu'

end

target 'ShareExtension' do
  shared_pods

  pod 'KeanuExtension', :path => '../../Keanu'
end
