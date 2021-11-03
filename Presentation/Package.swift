// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Presentation",
  products: [
    .library(
      name: "Presentation",
      targets: ["Presentation"]),
  ],
  dependencies: [
    
  ],
  targets: [
    .target(
      name: "Presentation",
      dependencies: [],
      path: "Presentation"
    ),
    .testTarget(
      name: "PresentationTests",
      dependencies: ["Presentation"]),
  ]
)
