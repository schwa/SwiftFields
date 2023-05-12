// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftFields",
    products: [
        .library(
            name: "SwiftFields",
            targets: ["SwiftFields"]),
    ],
    dependencies: [
        .package(url: "https://github.com/schwa/SwiftFormats", branch: "main")
    ],
    targets: [
        .target(
            name: "SwiftFields"),
        .testTarget(
            name: "SwiftFieldsTests",
            dependencies: ["SwiftFields"]),
    ]
)
