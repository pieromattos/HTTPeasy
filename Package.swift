// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "HTTPeasy",
    products: [
        .library(
            name: "HTTPeasy",
            targets: ["HTTPeasy"]
        )
    ],
    targets: [
        .target(
            name: "HTTPeasy",
            path: "HTTPeasy"
        ),
        .testTarget(
            name: "HTTPeasyTests",
            dependencies: ["HTTPeasy"],
            path: "HTTPeasyTests"
        )
    ]
)
