// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Platform",
  platforms: [.iOS(.v15)],
  products: [
    .library(name: "Platform", targets: [
      "HTTPNetwork",
      "UserDefaults"
    ]),
    .library(name: "PlatformImp", targets: [
      "HTTPNetworkImp",
      "UserDefaultsImp"
    ]),
    .library(name: "PlatformTestSupport", targets: [
      "HTTPNetworkTestSupprt",
      "UserDefautsTestSupprt"
    ])
  ],
  dependencies: [
    
  ],
  targets: [
    .target(name: "HTTPNetwork", dependencies: [], path: "HTTPNetwork/Interface"),
    .target(name: "HTTPNetworkImp",dependencies: ["HTTPNetwork"], path: "HTTPNetwork/Implementation"),
    .testTarget(name: "HTTPNetworkImpTests", dependencies: ["HTTPNetworkImp"], path: "HTTPNetwork/Tests"),
    .target(name: "HTTPNetworkTestSupprt", dependencies: ["HTTPNetwork"], path: "HTTPNetwork/TestSupport"),
    
    .target(name: "UserDefaults", dependencies: [], path: "UserDefaults/Protocol"),
    .target(name: "UserDefaultsImp",dependencies: ["UserDefaults"], path: "UserDefaults/Implementation"),
    .target(name: "UserDefautsTestSupprt", dependencies: ["UserDefaults"], path: "UserDefaults/TestSupport"),
  ]
)
