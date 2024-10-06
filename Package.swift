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
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor-community/sendgrid-kit.git", from: "3.0.0-rc.1"),
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
        ),
    ]
)

var swiftSettings: [SwiftSetting] {
    [
        .enableUpcomingFeature("ExistentialAny")
    ]
}
