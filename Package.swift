import PackageDescription

let package = Package(
    name: "Mail",
    targets: [
        Target(
            name: "Mail"
        ),
        Target(
            name: "SendGrid",
            dependencies: [
                "Mail"
            ]
        ),
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 5),
    ]
)
