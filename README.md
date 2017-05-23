# Mail

![Swift](http://img.shields.io/badge/swift-3.1-brightgreen.svg)
![Vapor](http://img.shields.io/badge/vapor-2.0-brightgreen.svg)
![Travis](https://travis-ci.org/vapor-community/mail.svg?branch=master)

[Render](#rendering-emails) HTML and plaintext emails using Vapor's views, then
[send](#sending-emails) them with confidence using your choice of native API
backends.

[Developers](#third-party-developers) can depend on `mail` to enable
backend-agnostic email sending in their Providers.

Mail includes swappable backends for the following services:

* [`Mailgun`](#mailgun), a basic implementation for sending emails through Mailgun's V3 API.
* [`SendGrid`](#sendgrid), a fully-featured implementation of the SendGrid V3 Mail Send API.
* [`SMTPClient`](#smtp), which conforms Vapor's built-in SMTP Client to this backend.

There are also two [development-only](#development-backends) backends:

* `InMemoryMailClient` stores emails in memory.
* `ConsoleMailClient` outputs emails to the console.

## 📘 Overview

### Rendering emails

Using Mail, you can use Views to generate emails in plain text or HTML with Leaf
or another templating language.

```Swift
import Mail

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

Simply add your choice of mail client provider to your Droplet for access to
frictionless mail sending. Configure your client using Config files, and swap
out your provider at any time.

```Swift
import Mail

let config = try Config()
try config.addProvider(Mail.Provider<ConsoleMailclient>.self)
let drop = try Droplet(config)

let email = Email(
    from: "from@email.com",
    to: "recipient1@email.com", "recipient2@email.com",
    subject: "Email subject",
    body: "Hello")
try drop.mailer?.send(email)
```

You can also directly instantiate your mail client, if you want:

```Swift
import Mail

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

### Third-party developers

Enable email-sending in your own Providers without tying your end-users to any
specific email backend by adding a dependency on `mail`
and simply calling:

```Swift
drop.mailer?.send(email)
```

If `drop.mailer` is `nil`, the user has not set up any email backend. If email
is an integral part of your Provider, you can check for this at set-up time
and throw a configuration error if there's no mailer present.

## 📘 Backends

### Mailgun

The Mailgun backend implements basic mail sending using the Mailgun V3 API.
Mailgun supports HTML and plain text emails.

First, add the Provider:

```Swift
import Mail
import Mailgun

let config = try Config()
try config.addProvider(Mail.Provider<MailgunClient>.self)
let drop = try Droplet()
```

Add a Config file named `mailgun.json` with the following format:

```json
{
    "domain": "MG.YOUR_DOMAIN",
    "apiKey": "MG.YOUR_API_KEY"
}
```

Now you can send simple emails using the following format:

```Swift
let email = Email(from: …, to: …, subject: …, body: …)
try drop.mailer?.send(email)
```

### SendGrid

In addition to sending simple HTML and plain text emails,
the SendGrid backend fully implements all the features of SendGrid's
[V3 Mail Send API](https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/index.html).

First, add the Provider:

```Swift
import Mail
import SendGrid

let config = try Config()
try config.addProvider(Mail.Provider<SendGridClient>.self)
let drop = try Droplet()
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
try drop.mailer?.send(email)
```

You can also send advanced emails by explicitly using `SendGridEmail` instances:

```Swift
let email = SendGridEmail(from: "from@test.com", templateId: "welcome_email")
email.personalizations.append(Personalization([
    to: "to@test.com"
]))
email.sandboxMode = true
email.openTracking = .enabled(nil)
if let sendgrid = try drop.mailer.make() as? SendGridClient {
    sendgrid.send(email)
}
```

See `SendGridEmail.swift` for all configuration options.

### SMTP

First, add the provider. Note that the client is named `SMTPMailClient` to
avoid conflicts with Vapor's own `SMTPClient`.

```Swift
import Mail
import SMTPClient

let config = try Config()
try config.addProvider(Mail.Provider<SMTPMailClient>.self)
let drop = try Droplet(config)
```

Add a Config file named `smtp.json` with the following format:

```json
{
    "scheme": "smtp",
    "hostname": "host.com",
    "port": 465,
    "username": "username",
    "password": "password"
}
```

Now you can send simple emails using the following format:

```Swift
let email = Email(from: …, to: …, subject: …, body: …)
try drop.mailer?.send(email)
```

All connections will use the scheme, host, port, username and password that you
set with the Provider. If you need to customise any of these per-send, you
should use Vapor's `SMTPClient` directly.

### Development backends

There are two options for testing your emails in development.

Emails sent by the `ConsoleMailClient` will be displayed in the console.

```Swift
import Mail

let config = try Config()
try config.addProvider(Mail.Provider<ConsoleMailclient>.self)
let drop = try Droplet(config)

let email = Email(
    from: "from@email.com",
    to: "recipient@email.com"
    subject: "Email subject",
    body: "Hello")
try drop.mailer?.send(email)
// Output to console
```

Emails sent by the `InMemoryMailClient` will be stored in the client's
`sentEmails` property.

```Swift
import Mail

let mailer = InMemoryMailClient()
let email = Email(
    from: "from@email.com",
    to: "recipient@email.com",
    subject: "Email subject",
    body: "Hello")
try mailer.send(email)
print(mailer.sentEmails)
```
