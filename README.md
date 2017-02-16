# Mail

![Swift](http://img.shields.io/badge/swift-3.0-brightgreen.svg)

Vapor Provider for sending email through swappable backends.

Backends included in this repository:

* `SendGrid`, a fully-featured implementation of the SendGrid V3 Mail Send API.
* `InMemoryMailClient`, a development-only backend which stores emails in memory.
* `ConsoleMailClient`, a development-only backend which outputs emails to the console.

SMTP is not included. Use Vapor's built in SMTPClient if you need to use the
SMTP protocol.

## 📘 Overview

Simply add your choice of mail client provider to your Droplet, for access to
frictionless mail sending. If you use `drop.mailer` to send emails, you can
change the provider at any time without affecting your mailing code.

```Swift
import Mail

let drop = Droplet()
try drop.addProvider(Mail.Provider<ConsoleMailClient>.self)

let email = Email(from: "from@email.com",
                  to: "to1@email.com", "to2@email.com",
                  subject: "Email Subject",
                  body: "Hello Email")
email.attachments.append(attachment)
try drop.mailer?.send(email)
```

You can also directly instantiate your mail client, if you want:

```Swift
import Mail

let mailer = ConsoleMailClient()
```

Individual backends directly implement any applicable extra features such as
variable authentication per send, or templated emails. To make use of these
features:

```Swift
if let complicatedMailer = try drop.mailer.make() as? ComplicatedMailClient {
    complicatedMailer.send(complicatedEmail)
}
```

### SendGrid backend

First, set up the Provider.

```Swift
import Mail
import SendGrid

let drop = Droplet()
try drop.addProvider(Mail.Provider<SendGridClient>.self)
```

SendGrid expects a configuration file named `sendgrid.json` with the following
format, and will throw `.noSendGridConfig` or `.missingConfig(fieldname)` if
configuration was not found.

```json
{
    "apiKey": "SG.YOUR_KEY"
}
```

Once installed, you can send simple emails using the following format:

```Swift
let email = Email(from: …, to: …, subject: …, body: …)
try drop.mailer?.send(email)
```

However, `SendGrid` supports the full range of options available in SendGrid's
[V3 Mail Send API](https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/index.html).

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

### Development backends

There are two options for testing your emails in development.

Any emails sent by the `InMemoryMailClient` will be stored in the client's
`sentEmails` property.

```Swift
import Mail

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
import Mail

let mailer = ConsoleMailClient()
let email = Email(from: "from@email.com",
                  to: "to1@email.com", "to2@email.com",
                  subject: "Email Subject",
                  body: "Hello Email")
email.attachments.append(attachment)
try mailer.send(email)
// Output to console
```
