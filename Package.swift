// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SendGrid",
    products: [
        .library(name: "SendGrid", targets: ["SendGrid"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc"),
        ],
    targets: [
        .target(name: "SendGrid", dependencies: ["Vapor"]),
        .testTarget(name: "SendGridTests", dependencies: ["Vapor", "SendGrid"])
    ]
)
