// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InfinityBottomSheet",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "InfinityBottomSheet", targets: ["InfinityBottomSheet"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "InfinityBottomSheet", dependencies: []),
        
       
        .testTarget(name: "InfinityBottomSheetTests", dependencies: ["InfinityBottomSheet"]),
    ]
)
