// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Presentation",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "Presentation",
      targets: ["Presentation"]),
  ],
  dependencies: [
    .package(name: "Proxy", path: "../Proxy"),
    .package(name: "Domain", path: "../Domain")
  ],
  targets: [
    .target(
      name: "Presentation",
      dependencies: [
        .product(name: "Proxy", package: "Proxy"),
        .product(name: "Domain", package: "Domain")
      ],
      path: "Presentation",
      resources: [.process("Resource")]
    ),
    .testTarget(
      name: "PresentationTests",
      dependencies: ["Presentation"]),
  ]
)
