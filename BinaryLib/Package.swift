// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BinaryLib",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BinaryLib",
            targets: [
                "BinaryLib",
                "Alamofire",
                "AnyCodable",
                "BoxKit",
                "KingFisher",
            ]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/chiahsien/CHTCollectionViewWaterfallLayout.git", .upToNextMajor(from: "0.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BinaryLib",
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
