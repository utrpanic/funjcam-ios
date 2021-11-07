// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Application",
  platforms: [.iOS(.v15)],
  products: [
    .library(name: "Application", targets: ["Application"]),
  ],
  dependencies: [
    .package(name: "Proxy", path: "../Proxy"),
    .package(name: "Domain", path: "../Domain"),
  ],
  targets: [
    .target(
      name: "Application",
      dependencies: ["Proxy", "Domain"],
      path: "Application",
      resources: [.process("Resource")]
    ),
    .testTarget(
      name: "ApplicationTests",
      dependencies: ["Application"]
    ),
  ]
)
