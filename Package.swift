// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PixelFlux",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Dynamic type ensures xcodebuild archive installs a .framework bundle
        // into Products/Library/Frameworks/ so XCFramework creation succeeds.
        .library(
            name: "PixelFlux",
            type: .dynamic,
            targets: ["PixelFlux"]
        )
    ],
    targets: [
        .target(
            name: "PixelFlux",
            path: "PixelFlux",
            exclude: [
                "demo.xcworkspace",
                ".DS_Store"
            ]
        ),
        .testTarget(
            name: "PixelFluxTests",
            dependencies: ["PixelFlux"],
            path: "Tests/PixelFluxTests"
        )
    ]
)
