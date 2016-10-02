# Uncomment this line to define a global platform for your project
platform :ios, '10.0'
use_frameworks!

target 'funjcam' do
    source 'https://github.com/CocoaPods/Specs.git'
    pod 'Alamofire'
    pod 'AlamofireImage'
    pod 'Crashlytics'
    pod 'Fabric'
    pod 'ObjectMapper'
    pod 'R.swift'
    pod 'RealmSwift'
    pod 'SDWebImage'

end

target 'funjcamTests' do

end

target 'funjcamUITests' do

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

