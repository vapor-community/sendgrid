// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "sendgrid",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "SendGrid", targets: ["SendGrid"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/fpseverino/sendgrid-kit.git", branch: "update"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SendGrid",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "SendGridKit", package: "sendgrid-kit"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SendGridTests",
            dependencies: [
                .target(name: "SendGrid"),
                .product(name: "XCTVapor", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("ConciseMagicFile"),
    .enableUpcomingFeature("ForwardTrailingClosures"),
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableUpcomingFeature("StrictConcurrency"),
    .enableExperimentalFeature("StrictConcurrency=complete"),
] }
