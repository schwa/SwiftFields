// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftFields",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "SwiftFields",
            targets: ["SwiftFields"]),
    ],
    dependencies: [
        .package(url: "https://github.com/schwa/SwiftFormats", from: "0.3.1")
    ],
    targets: [
        .target(
            name: "SwiftFields",
            dependencies: [
                "SwiftFormats"
            ]
        ),
        .testTarget(
            name: "SwiftFieldsTests",
            dependencies: [
                "SwiftFields"
            ]
        ),
    ]
)
