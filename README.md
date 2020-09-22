# SendGrid Provider for Vapor

<p align="center">
    <a href="https://github.com/vapor-community/sendgrid/actions">
        <img src="https://github.com/vapor-community/sendgrid/workflows/test/badge.svg" alt="Continuous Integration">
    </a>
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/swift-5.2-brightgreen.svg" alt="Swift 5.2">
    </a>
</p>

Adds a mail backend for SendGrid to the Vapor web framework. Send simple emails,
or leverage the full capabilities of SendGrid's V3 API.

## Setup
Add the dependency to Package.swift:

~~~~swift
.package(url: "https://github.com/vapor-community/sendgrid.git", from: "4.0.0")
~~~~

~~~~swift
.target(name: "App", dependencies: [
    .product(name: "SendGrid", package: "sendgrid"),
    .product(name: "Vapor", package: "vapor"),
]),
~~~~

Make sure `SENDGRID_API_KEY` is set in your environment. This can be set in the
Xcode scheme, or specified in your `docker-compose.yml`, or even provided as
part of a `swift run` command.

To set it in the Xcode Scheme you can click in edit scheme and it shows a list of
Environment Variables where you can create a new entry for `SENDGRID_API_KEY`.

![Xcode Scheme SendGrid API Key Environment Variables](XcodeSchemeSendGrid.png?raw=true "Xcode Scheme SendGrid API Key Environment Variables")

## Initialize

Optionally, explicitly initialize the provider (this is strongly recommended, as
otherwise a missing API key will cause a fatal error some time later in your
application):

~~~~swift
app.sendgrid.initialize()
~~~~

Now you can access the client at any time:
~~~~swift
app.sendgrid.client
~~~~

## Using the API

You can use all of the available parameters here to build your `SendGridEmail`
Usage in a route closure would be as followed:

~~~~swift
import SendGrid

let email = SendGridEmail(…)

return req.application.sendgrid.client.send([email], on: req.eventLoop)
~~~~

## Error handling
If the request to the API failed for any reason a `SendGridError` is the result
of the future, and has an `errors` property that contains an array of errors
returned by the API:

~~~~swift
return req.application.sendgrid.client.send([email], on: req.eventLoop).flatMapError { error in
    if let sendgridError = error as? SendGridError {
        req.logger.error("\(error)")
    }
    // ...
}
~~~~
