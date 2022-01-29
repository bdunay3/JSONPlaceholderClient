// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "RESTClient",
            targets: ["RESTClient"]),
    ],
    dependencies: [
        .package(name: "Models", path: "../Models")
    ],
    targets: [        
        .target(
            name: "RESTClient",
            dependencies: ["Models"]),
        .testTarget(
            name: "RESTClientTests",
            dependencies: ["RESTClient"]),
    ]
)
