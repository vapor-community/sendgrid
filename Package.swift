// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "sendgrid",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "SendGrid", targets: ["SendGrid"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.112.0"),
        .package(url: "https://github.com/vapor-community/sendgrid-kit.git", from: "3.0.0"),
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
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)

var swiftSettings: [SwiftSetting] {
    [
        .enableUpcomingFeature("ExistentialAny")
    ]
}
