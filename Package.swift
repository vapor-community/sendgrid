import PackageDescription

let package = Package(
    name: "SendGrid",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
    ]
)
