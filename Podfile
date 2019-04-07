platform :ios, '12.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

def pods
    source 'https://github.com/CocoaPods/Specs.git'
    pod 'Alamofire'
    pod 'CHTCollectionViewWaterfallLayout/Swift'
    pod 'Crashlytics'
    pod 'Fabric'
    pod 'Firebase'
    pod 'Kingfisher'
    pod 'RxSwift'
    pod 'SwiftLint'
    pod 'Texture'
    pod 'Toaster'
    
    pod 'BoxJeonExtension', :git => 'https://github.com/utrpanic/boxjeon-extension.git', :tag => 'v1.5', :inhibit_warnings => false
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
