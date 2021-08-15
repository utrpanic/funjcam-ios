platform :ios, '14.0'

use_frameworks!

inhibit_all_warnings!

source 'https://github.com/CocoaPods/Specs.git'

def pod_Common
  pod 'BoxKit', :git => 'https://github.com/utrpanic/box-kit-ios.git', :tag => 'v2.2.1'
  pod 'ReactorKit'
  pod 'RxSwift'
end

def modelPods
  pod_Common
  pod 'Alamofire'
end

def funJCamPods
  pod_Common
  pod 'CHTCollectionViewWaterfallLayout/Swift'
  pod 'Firebase/Core'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'Kingfisher'
  pod 'KingfisherWebP'
  pod 'SwiftLint'
  pod 'Toaster'
end

target 'Model' do
  modelPods
end

target 'ModelTests' do
  modelPods
end

target 'FunJCam' do
  funJCamPods
end

target 'FunJCamTests' do
  funJCamPods
end

target 'FunJCamUITests' do
  funJCamPods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Xcode12가 iOS8 지원을 종료하면서...
      # deployment target이 iOS8로 되어 있는 라이브러리에 대해 waning을 발생시킴.
      # Cocoapods에서 대응해주지 않을까 싶어 기다리다가 찾아봤는데...
      # Xcode11에서도 동일한 상황이 발생했었음.(deployment target iOS7 라이브러리 대해 warning.)
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
