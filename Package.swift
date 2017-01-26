import PackageDescription

let dependencies: [Package.Dependency] = [
    .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 4),
]

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
        // Target(
        //     name: "SMTP",
        //     dependencies: [
        //         "Mail"
        //     ]
        // ),
        // Target(
        //     name: "SMTPExample",
        //     dependencies: [
        //         "SMTP"
        //     ]
        // )
    ],
    dependencies: dependencies,
    exclude: [
        // "Resources",
        // "Sources/SMTPClientExample",
    ]
)
