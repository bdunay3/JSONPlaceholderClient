// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UI",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "UI",
            targets: ["UI"]),
    ],
    dependencies: [
        .package(name: "Dependencies", path: "../Dependencies"),
        .package(name: "Models", path: "../Models"),
        .package(name: "VSM", url: "https://github.csnzoo.com/shared/vsm-ios", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "UI",
            dependencies: [
                "Dependencies",
                "Models",
                "VSM"
            ]),
        .testTarget(
            name: "UITests",
            dependencies: ["UI"]),
    ]
)
