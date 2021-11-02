// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Proxy",
  products: [
    .library(
      name: "Proxy",
      targets: [
        "Proxy",
        "Alamofire",
        "AnyCodable",
        "BoxKit",
        "KingFisher",
      ]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/ReactorKit/ReactorKit.git", .upToNextMajor(from: "3.0.0")),
    .package(url: "https://github.com/chiahsien/CHTCollectionViewWaterfallLayout.git", .upToNextMajor(from: "0.0.0")),
  ],
  targets: [
    .target(
      name: "Proxy",
      dependencies: [
        "CHTCollectionViewWaterfallLayout",
        "ReactorKit",
      ]),
    .binaryTarget(name: "Alamofire", path: "Carthage/Build/Alamofire.xcframework"),
    .binaryTarget(name: "AnyCodable", path: "Carthage/Build/AnyCodable.xcframework"),
    .binaryTarget(name: "BoxKit", path: "Carthage/Build/BoxKit.xcframework"),
    .binaryTarget(name: "KingFisher", path: "Carthage/Build/KingFisher.xcframework"),
  ]
)
