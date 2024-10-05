# ``SendGrid``

📧 SendGrid library for the Vapor web framework, based on SendGridKit.

## Overview

Send simple emails, or leverage the full capabilities of SendGrid's V3 API.

> Warning:  Make sure that the `SENDGRID_API_KEY` variable is set in your environment.
This can be set in the Xcode scheme, or specified in your `docker-compose.yml`, or even provided as part of a `swift run` command.
A missing API key will result in a fatal error.

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
