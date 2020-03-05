# SendGrid Provider for Vapor

![Swift](http://img.shields.io/badge/swift-5.2-brightgreen.svg)
![Vapor](http://img.shields.io/badge/vapor-4.0-brightgreen.svg)
[![CircleCI](https://circleci.com/gh/vapor-community/sendgrid-provider.svg?style=shield)](https://circleci.com/gh/vapor-community/sendgrid-provider)

Adds a mail backend for SendGrid to the [Vapor web framework](https://vapor.codes/). Send simple emails,
or leverage the full capabilities of SendGrid's V3 API.

## Setup

Add the dependency to your `Package.swift`:

~~~~swift
.package(url: "https://github.com/vapor-community/sendgrid-provider.git", from: "3.0.0")

// …

.product(name: "SendGrid", package: "sendgrid-provider")
~~~~

Configure your SendGrid API key:

~~~~swift
application.sendgridClient.configuration.apiKey = "SG.something"
~~~~

The client is now ready to use!

## Using the API

Instantiate an instance of `SendGridEmail`, then use the client to send it:

~~~~swift
import SendGrid

let email = SendGridEmail(…)

try application.sendgridClient.send([email], on: req.eventLoop)
~~~~

## Error handling

If a request to the API failed for any reason, a `SendGridError` is thrown and has an `errors` property that contains an array of errors returned by SendGrid's API.

Ensure that you catch errors thrown, just as you would with any other throwing function:

~~~~swift
do {
    try application.sendgridClient.send(...)
} catch let error as SendGridError {
    print(error)
}
~~~~
