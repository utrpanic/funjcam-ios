// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Platform",
  products: [
    .library(name: "Platform", targets: [
      "Network"
    ]),
    .library(name: "PlatformImp", targets: [
      "NetworkImp"
    ]),
  ],
  dependencies: [
    .package(name: "Proxy", path: "../Proxy"),
  ],
  targets: [
    .target(name: "Network",
            dependencies: [],
            path: "Network/Protocol"),
    .target(name: "NetworkImp",
            dependencies: ["Proxy", "Network"],
            path: "Network/Implementation"),
    .testTarget(name: "NetworkTests",
                dependencies: ["NetworkImp"],
                path: "Network/Test"),
  ]
)
