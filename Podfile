platform :ios, '13.0'

use_frameworks!

inhibit_all_warnings!

source 'https://github.com/CocoaPods/Specs.git'

def pod_BoxKit
  pod 'BoxKit', :git => 'https://github.com/utrpanic/box-kit-ios.git', :tag => 'v2.1.7'
end

def modelPods
  pod 'Alamofire'
  pod 'ReactorKit'
  pod 'RxSwift'
  pod_BoxKit
end

def funcJCamPods
  pod 'CHTCollectionViewWaterfallLayout/Swift'
  pod 'Crashlytics'
  pod 'Fabric'
  pod 'Firebase'
  pod 'Kingfisher'
  pod 'KingfisherWebP'
  pod 'ReactorKit'
  pod 'RxSwift'
  pod 'SwiftLint'
  pod 'Toaster'

  pod_BoxKit
end

target 'Model' do
  modelPods
end

target 'ModelTests' do
  modelPods
end

target 'FunJCam' do
  funcJCamPods
end

target 'FunJCamTests' do
  funcJCamPods
end

target 'FunJCamUITests' do
  funcJCamPods
end
