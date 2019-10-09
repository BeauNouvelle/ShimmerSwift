// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "ShimmerSwift",
    products: [
        .library(name: "ShimmerSwift", targets: ["ShimmerSwift"]),
    ],
    dependencies: [
    ],
    targets: [
        // SwiftChart
        .target(name: "ShimmerSwift", dependencies: [
        ], path: "Shimmer"),
    ]
)
