import PackageDescription

let package = Package(
    name: "Airmail",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
    ],
    exclude: [
        "Sources/Airmail/Mailgun",
        "Sources/Airmail/SendGrid",
        "Tests/MailgunTests",
        "Tests/SendGridTests",
    ]
)
