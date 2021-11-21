// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Domain",
  platforms: [.iOS(.v15)],
  products: [
    .library(name: "Entity", targets: [
      "Entity"
    ]),
    .library(name: "Domain", targets: [
      "Usecase"
    ]),
    .library(name: "DomainImp", targets: [
      "UsecaseImp"
    ]),
    .library(name: "DomainTestSupport", targets: [
      "UsecaseTestSupport"
    ])
  ],
  dependencies: [
    .package(name: "Proxy", path: "../Proxy"),
    .package(name: "Platform", path: "../Platform")
  ],
  targets: [
    .target(name: "Entity", dependencies: [], path: "Entity"),
    
    .target(name: "Usecase", dependencies: [.product(name: "Platform", package: "Platform"), "Entity"], path: "Usecase/Interface"),
    .target(name: "UsecaseImp", dependencies: ["Usecase"], path: "Usecase/Implementation"),
    .target(name: "UsecaseTestSupport", dependencies: ["Usecase"], path: "Usecase/TestSupport"),
  ]
)
