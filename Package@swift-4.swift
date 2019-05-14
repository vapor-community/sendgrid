// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SendGridProvider",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.3.0")),
    ]
)
