// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "custom_camera",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "custom-camera", targets: ["custom_camera"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "custom_camera_internal",
            path: "Sources/custom_camera_internal",
            resources: [
                .process("Resources/Assets.xcassets")
            ],
            publicHeadersPath: "include"
        ),
        .target(
            name: "custom_camera",
            dependencies: ["custom_camera_internal"],
            path: "Sources/custom_camera"
        )
    ]
)
