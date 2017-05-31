# Airmail

![Swift](http://img.shields.io/badge/swift-3.1-brightgreen.svg)
![Vapor](http://img.shields.io/badge/vapor-2.0-brightgreen.svg)
![Travis](https://travis-ci.org/vapor-community/mail.svg?branch=master)

[Render](#rendering-emails) HTML and plaintext emails using Vapor's views, then
[send](#sending-emails) them with confidence using your choice of native API
backends.

Airmail extends Vapor's built-in mailer with backends for the following services:

* [`Mailgun`](#mailgun), adds mailing list subscriber management to Vapor's own client.
* [`SendGrid`](#sendgrid), a fully-featured implementation of the SendGrid V3 Mail Send API.

There are also two [development-only](#development-backends) backends:

* `InMemoryMailClient` stores emails in memory.
* `ConsoleMailClient` outputs emails to the console.

## 📘 Overview

### Rendering emails

Using Airmail, you can use Views to generate emails in plain text or HTML with Leaf
or another templating language.

```Swift
import Airmail

let drop = try Droplet()

let body = try EmailBody(drop, type: .html, view: "email", [
    "firstName": "Peter",
    "lastName": "Pan",
])
let email = Email(
    from: "from@email.com",
    to: "recipient@email.com",
    subject: "Email subject",
    body: body)
```

Of course, if you are using an advanced email backend like SendGrid you may want
to use your mail provider's templating system instead; see the individual
[backends](#backends) below for more details.

### Sending emails

Simply add your choice of mail client to your Droplet for access to
frictionless mail sending. Configure your client using Config files, and swap
out your backend at any time.

```Swift
import Airmail

let config = try Config()
let drop = try Droplet(
    config: config,
    mail: SendGrid(config: config)
)

let email = Email(
    from: "from@email.com",
    to: "recipient1@email.com", "recipient2@email.com",
    subject: "Email subject",
    body: "Hello")
try drop.mail.send(email)
```

You can also directly instantiate your mail client, if you want:

```Swift
import Airmail

let mailer = ConsoleMailClient()
try mailer.send(email)
```

Individual backends directly implement any applicable extra features such as
variable authentication per send, or templated emails. Refer to the
[backends](#backends) below for information.

### Attachments

Use Vapor's `EmailAttachment` class:

```Swift
let attachment = EmailAttachment(
    filename: "dummy.data",
    contentType: "dummy/data",
    body: [1,2,3,4,5])
email.attachments.append(attachment)
```

## 📘 Backends

### Mailgun

Vapor already includes a Mailgun API client. This backend extends that client
to allow you to programmatically add mailing list subscribers.

First, set up the mail client:

```Swift
import Airmail

let config = try Config()
let drop = try Droplet(
    config: config,
    mail: Mailgun(config: config)
)
```

Add a Config file named `mailgun.json` with the following format:

```json
{
    "domain": "MG.YOUR_DOMAIN",
    "key": "MG.YOUR_API_KEY"
}
```

Now you can send simple emails using the following format:

```Swift
let email = Email(from: …, to: …, subject: …, body: …)
try drop.mail.send(email)
```

### SendGrid

In addition to sending simple HTML and plain text emails,
the SendGrid backend fully implements all the features of SendGrid's
[V3 Mail Send API](https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/index.html).

First, set up the mail client:

```Swift
import Airmail

let config = try Config()
let drop = try Droplet(
    config: config,
    mail: SendGrid(config: config)
)
```

Add a Config file named `sendgrid.json` with the following format:

```json
{
    "apiKey": "SG.YOUR_API_KEY"
}
```

Now you can send simple emails using the following format:

```Swift
let email = Email(from: …, to: …, subject: …, body: …)
try drop.mail.send(email)
```

You can also send advanced emails by explicitly using `SendGridEmail` instances:

```Swift
let email = SendGridEmail(from: "from@test.com", templateId: "welcome_email")
email.personalizations.append(Personalization([
    to: "to@test.com"
]))
email.sandboxMode = true
email.openTracking = .enabled(nil)
if let sendgrid = try drop.mail as? SendGrid {
    sendgrid.send(email)
}
```

See `SendGridEmail.swift` for all configuration options.

### Development backends

There are two options for testing your emails in development.

Emails sent by the `ConsoleMailClient` will be displayed in the console.

```Swift
import Airmail

let drop = try Droplet(mail: ConsoleMailClient())

let email = Email(
    from: "from@email.com",
    to: "recipient@email.com"
    subject: "Email subject",
    body: "Hello")
try drop.mail.send(email)
// Output to console
```

Emails sent by the `InMemoryMailClient` will be stored in the client's
`sentEmails` property.

```Swift
import Airmail

let mailer = InMemoryMailClient()
let email = Email(
    from: "from@email.com",
    to: "recipient@email.com",
    subject: "Email subject",
    body: "Hello")
try mailer.send(email)
print(mailer.sentEmails)
```
