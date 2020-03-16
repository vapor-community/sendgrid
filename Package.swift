// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "SendGrid",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "SendGrid", targets: ["SendGrid"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-rc"),
        .package(url: "https://github.com/vapor-community/sendgrid-kit.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "SendGrid", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "SendGridKit", package: "sendgrid-kit"),
        ]),
        .testTarget(name: "SendGridTests", dependencies: ["SendGrid"])
    ]
)
