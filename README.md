# Mail

![Swift](http://img.shields.io/badge/swift-3.0-brightgreen.svg)
[![Build Status](https://travis-ci.org/vapor/mail.svg?branch=master)](https://travis-ci.org/vapor/mail)
[![CircleCI](https://circleci.com/gh/vapor/mail.svg?style=shield)](https://circleci.com/gh/vapor/mail)
[![Code Coverage](https://codecov.io/gh/vapor/mail/branch/master/graph/badge.svg)](https://codecov.io/gh/vapor/mail)
[![Slack Status](http://vapor.team/badge.svg)](http://vapor.team)

First-class support for sending email through swappable backends. It is used as
the core email layer in [Vapor](https://github.com/qutheory/github).

Backends included in this repository:

* `SMTPClient`, for sending emails through plain SMTP.
* `InMemoryMailClient`, a development-only backend which stores emails in memory.
* `ConsoleMailClient`, a development-only backend which outputs emails to the console.

## 📦 Examples

Check out the SMTPClient example in `Sources/`. You can clone this repository and run it on your computer.

## 📘 Overview

### MailClient

Email backends conforming to MailClient have a `send(_:)` method which allows
simple sending of one or more emails.

```Swift
import MailClient

let mailer = try ... // Instantiate chosen MailClient backend
let email = Email(from: "from@email.com",
                  to: "to1@email.com", "to2@email.com",
                  subject: "Email Subject",
                  body: "Hello Email")
let attachment = EmailAttachment(filename: "image.jpg",
                                 contentType: "image/jpeg",
                                 body: fileBody)
email.attachments.append(attachment)
try mailer.send(email)
```

Individual backends directly implement any applicable extra features such as
variable authentication per send.

### SMTPClient

```Swift
import SMTP
import Foundation
import Transport

let credentials = SMTPCredentials(
    user: "server-admin-login",
    pass: "secret-server-password"
)
let client = try SMTPClient<TCPClientStream>(host: "smtp.host.com",
    port: 25, securityLayer: .tls(nil), credentials: credentials)

let from = EmailAddress(name: "Password Reset",
                        address: "noreply@myapp.com")
let to = "some-user@random.com"
let email: Email = Email(from: from,
                         to: to,
                         subject: "Vapor SMTP - Simple",
                         body: "Hello from Vapor SMTP 👋")
try client.send(email)
```

Or, set credentials separately for each send:

```Swift
let client = try SMTPClient<TCPClientStream>(host: "smtp.host.com",
    port: 25, securityLayer: .tls(nil))
let credentials = SMTPCredentials(
    user: "server-admin-login",
    pass: "secret-server-password"
)
try client.send(email, using: credentials)
```

> Emails using the Gmail client are blocked by default unless you enable access for less-secure apps in your Gmail account settings: https://support.google.com/accounts/answer/6010255?hl=en-GB

### Development backends

There are two options for testing your emails in development.

Any emails sent by the `InMemoryMailClient` will be stored in the client's
`sentEmails` property.

```Swift
let mailer = InMemoryMailClient()
let email = Email(from: "from@email.com",
                  to: "to1@email.com", "to2@email.com",
                  subject: "Email Subject",
                  body: "Hello Email")
email.attachments.append(attachment)
try mailer.send(email)
print(mailer.sentEmails)
```

Emails sent by the `ConsoleMailClient` will be displayed in the console.

```Swift
let mailer = ConsoleMailClient()
let email = Email(from: "from@email.com",
                  to: "to1@email.com", "to2@email.com",
                  subject: "Email Subject",
                  body: "Hello Email")
email.attachments.append(attachment)
try mailer.send(email)
// Output to console
```

## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to use this package.

## 💧 Community

Join the welcoming community of fellow Vapor developers in [slack](http://vapor.team).

## 🔧 Compatibility

This package has been tested on macOS and Ubuntu.
