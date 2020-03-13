# SendGrid Provider for Vapor

![Swift](http://img.shields.io/badge/swift-5.2-brightgreen.svg)
![Vapor](http://img.shields.io/badge/vapor-4.0-brightgreen.svg)
[![CircleCI](https://circleci.com/gh/vapor-community/sendgrid-provider.svg?style=shield)](https://circleci.com/gh/vapor-community/sendgrid-provider)

Adds a mail backend for SendGrid to the Vapor web framework. Send simple emails,
or leverage the full capabilities of SendGrid's V3 API.

## Setup
Add the dependency to Package.swift:

~~~~swift
dependencies: [
	...
	.package(url: "https://github.com/vapor-community/sendgrid-provider.git", from: "4.0.0")
],
targets: [
    .target(name: "App", dependencies: [
        .product(name: "SendGrid", package: "sendgrid-provider"),
    ]),
~~~~

Register the config and the provider.

~~~~swift
let sendgridClient = SendGridClient(client: app.client, apiKey: "YOUR_API_KEY")
~~~~

## Using the API

You can use all of the available parameters here to build your `SendGridEmail`
Usage in a route closure would be as followed:

~~~~swift
import SendGrid

let email = SendGridEmail(…)
let sendGridClient = try req.make(SendGridClient.self)

try sendGridClient.send([email], on: req.eventLoop)
~~~~

## Error handling
If the request to the API failed for any reason a `SendGridError` is `thrown` and has an `errors` property that contains an array of errors returned by the API.
Simply ensure you catch errors thrown like any other throwing function

~~~~swift
do {
    try sendgridClient.send(...)
}
catch let error as SendGridError {
    print(error)
}
~~~~
