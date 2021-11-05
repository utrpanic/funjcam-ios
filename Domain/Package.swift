// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Domain",
  platforms: [.iOS(.v15)],
  products: [
    .library(name: "Domain", targets: ["Domain"])
  ],
  dependencies: [
    .package(name: "Proxy", path: "../Proxy"),
    .package(name: "Platform", path: "../Platform")
      
  ],
  targets: [
    .target(
      name: "Domain",
      dependencies: ["Proxy", "Platform"],
      path: "Domain"
    ),
    .testTarget(
      name: "DomainTests",
      dependencies: ["Domain"])
  ]
)
