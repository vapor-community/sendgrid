// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "SendGrid",
    platforms: [
       .macOS(.v10_15),
    ],
    products: [
        .library(name: "SendGrid", targets: ["SendGrid"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-rc"),
    ],
    targets: [
        .target(name: "SendGrid", dependencies: [
            .product(name: "Vapor", package: "vapor")
        ]),
        .testTarget(name: "SendGridTests", dependencies: [
            .target(name: "SendGrid"),
        ])
    ]
)
