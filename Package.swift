// swift-tools-version:5.1
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
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-beta.3.1"),
        ],
    targets: [
        .target(name: "SendGrid", dependencies: ["Vapor"]),
        .testTarget(name: "SendGridTests", dependencies: ["Vapor", "SendGrid"])
    ]
)
