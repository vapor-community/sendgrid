import PackageDescription

let package = Package(
    name: "SendGridProvider",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
    ]
)
