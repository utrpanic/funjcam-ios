// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Domain",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "Domain",
      targets: ["Domain"])
  ],
  dependencies: [
    .package(name: "Proxy", path: "../Proxy")
  ],
  targets: [
    .target(
      name: "Domain",
      dependencies: [.product(name: "Proxy", package: "Proxy")]),
    .testTarget(
      name: "DomainTests",
      dependencies: ["Domain"])
  ]
)
