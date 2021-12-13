// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Proxy",
  products: [
    .library(name: "Proxy", targets: ["Proxy"]),
  ],
  dependencies: [
    .package(name: "SQLite.swift", url: "https://github.com/stephencelis/SQLite.swift.git", .upToNextMajor(from: "0.0.0")),
    .package(name: "TinyConstraints", url: "https://github.com/roberthein/TinyConstraints.git", .upToNextMajor(from: "4.0.0"))
  ],
  targets: [
    .target(
      name: "Proxy",
      dependencies: [
        "AnyCodable",
        "BoxKit",
        "KingFisher",
        .product(name: "SQLite", package: "SQLite.swift"),
        .product(name: "TinyConstraints", package: "TinyConstraints"),
      ]
    ),
    .binaryTarget(name: "AnyCodable", path: "Carthage/Build/AnyCodable.xcframework"),
    .binaryTarget(name: "BoxKit", path: "Carthage/Build/BoxKit.xcframework"),
    .binaryTarget(name: "KingFisher", path: "Carthage/Build/KingFisher.xcframework"),
  ]
)
