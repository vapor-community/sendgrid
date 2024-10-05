<div align="center">
    <img src="https://avatars.githubusercontent.com/u/26165732?s=200&v=4" width="100" height="100" alt="avatar" />
    <h1>SendGrid</h1>
    <a href="https://swiftpackageindex.com/vapor-community/sendgrid/documentation">
        <img src="https://design.vapor.codes/images/readthedocs.svg" alt="Documentation">
    </a>
    <a href="https://discord.gg/vapor"><img src="https://design.vapor.codes/images/discordchat.svg" alt="Team Chat"></a>
    <a href="LICENSE"><img src="https://design.vapor.codes/images/mitlicense.svg" alt="MIT License"></a>
    <a href="https://github.com/vapor-community/sendgrid/actions/workflows/test.yml">
        <img src="https://img.shields.io/github/actions/workflow/status/vapor-community/sendgrid/test.yml?event=push&style=plastic&logo=github&label=tests&logoColor=%23ccc" alt="Continuous Integration">
    </a>
    <a href="https://codecov.io/github/vapor-community/sendgrid">
        <img src="https://img.shields.io/codecov/c/github/vapor-community/sendgrid?style=plastic&logo=codecov&label=codecov">
    </a>
    <a href="https://swift.org">
        <img src="https://design.vapor.codes/images/swift60up.svg" alt="Swift 6.0+">
    </a>
</div>
<br>

📧 SendGrid library for the Vapor web framework, based on [SendGridKit](https://github.com/vapor-community/sendgrid-kit).

Send simple emails, or leverage the full capabilities of [SendGrid's V3 API](https://www.twilio.com/docs/sendgrid/api-reference/mail-send/mail-send).

### Getting Started

Use the SPM string to easily include the dependendency in your `Package.swift` file

```swift
.package(url: "https://github.com/vapor-community/sendgrid.git", from: "4.0.0")
```

and add it to your target's dependencies:

```swift
.product(name: "SendGrid", package: "sendgrid")
```

## Overview

> [!NOTE]
> Make sure that the `SENDGRID_API_KEY` variable is set in your environment.
This can be set in the Xcode scheme, or specified in your `docker-compose.yml`, or even provided as part of a `swift run` command.

### Using the API

You can use all of the available parameters here to build your `SendGridEmail`.

Usage in a route closure would be as followed:

```swift
import SendGrid

let email = SendGridEmail(…)
try await req.sendgrid.client.send(email)
```

### Error handling

If the request to the API failed for any reason a `SendGridError` is thrown, which has an `errors` property that contains an array of errors returned by the API.

Simply ensure you catch errors thrown like any other throwing function.

```swift
do {
	try await req.sendgrid.client.send(email)
} catch let error as SendGridError {
	req.logger.error("\(error.errors)")
}
```
