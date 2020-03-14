platform :ios, '13.0'

use_frameworks!

inhibit_all_warnings!

source 'https://github.com/CocoaPods/Specs.git'

def pods
  pod 'Alamofire'
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

  pod 'BoxKit', :git => 'https://github.com/utrpanic/box-kit-ios.git', :tag => 'v2.1.7'
end

target 'FunJCam' do
  pods
end

target 'FunJCamTests' do
  pods
end

target 'FunJCamUITests' do
  pods
end
