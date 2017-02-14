import PackageDescription

let package = Package(
    name: "Mail",
    targets: [
        Target(
            name: "Mail"
        ),
        Target(
            name: "ConsoleMailClient",
            dependencies: [
                "Mail"
            ]
        ),
        Target(
            name: "InMemoryMailClient",
            dependencies: [
                "Mail"
            ]
        ),
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 5),
    ]
)
