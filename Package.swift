// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-svd",
    platforms: [.macOS(.v13)],
    products: [
        .library(
            name: "SVD",
            targets: ["SVD"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "SVD"),
        .executableTarget(
            name: "SVDSwiftMMIO",
            dependencies: [
                "SVD",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "SVDTests",
            dependencies: ["SVD", "SVDSwiftMMIO"]),
    ]
)
