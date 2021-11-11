// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Platform",
  platforms: [.iOS(.v15)],
  products: [
    .library(name: "Platform", targets: [
      "Network",
      "UserDefaults"
    ]),
    .library(name: "PlatformImp", targets: [
      "NetworkImp",
      "UserDefaultsImp"
    ]),
    .library(name: "PlatformTestSupport", targets: [
      "NetworkTestSupprt",
      "UserDefautsTestSupprt"
    ])
  ],
  dependencies: [
    
  ],
  targets: [
    .target(name: "Network", dependencies: [], path: "Network/Interface"),
    .target(name: "NetworkImp",dependencies: ["Network"], path: "Network/Implementation"),
    .testTarget(name: "NetworkTests", dependencies: ["NetworkImp"], path: "Network/Tests"),
    .target(name: "NetworkTestSupprt", dependencies: ["Network"], path: "Network/TestSupport"),
    
    .target(name: "UserDefaults", dependencies: [], path: "UserDefaults/Protocol"),
    .target(name: "UserDefaultsImp",dependencies: ["UserDefaults"], path: "UserDefaults/Implementation"),
    .target(name: "UserDefautsTestSupprt", dependencies: ["UserDefaults"], path: "UserDefaults/TestSupport"),
  ]
)
