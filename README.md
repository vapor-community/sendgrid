# Mail

![Swift](http://img.shields.io/badge/swift-3.0-brightgreen.svg)
![Vapor](http://img.shields.io/badge/vapor-1.5-brightgreen.svg)

Vapor Provider for sending email through swappable backends.

Backends included in this repository:

* `SendGrid`, a fully-featured implementation of the SendGrid V3 Mail Send API.
* `SMTPClient`, which conforms Vapor's built-in SMTP Client to this backend.
* `Mailgun`, a basic implementation for sending emails through Mailgun's V3 API.
* `InMemoryMailClient`, a development-only backend which stores emails in memory.
* `ConsoleMailClient`, a development-only backend which outputs emails to the console.

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

### SMTPClient

First, set up the Provider. Note that the security layer and stream types are
not loaded from config, and must be set in code.

```Swift
import Mail
import SMTPClient

let drop = Droplet()
SMTPClient<TCPClientStream>.setSecurityLayer(.tls(nil))
try drop.addProvider(Mail.Provider<SMTPClient<TCPClientStream>>.self)
```

SMTPClient expects a configuration file named `smtp.json` with the following
format, and will throw `.noSMTPConfig` or `.missingConfig(fieldname)` if
configuration was not found.

```json
{
    "host": "smtp.host.com",
    "port": 465,
    "username": "username",
    "password": "password"
}
```

Once installed, you can send emails using the following format:

```Swift
let email = Email(from: …, to: …, subject: …, body: …)
try drop.mailer?.send(email)
```

All connections will use the host, port, username, password, stream type and
security layer that you set with the Provider. If you need to customise any of
these per-send, you should use Vapor's `SMTPClient` directly.

### Mailgun backend

First, set up the Provider.

```Swift
import Mail
import Mailgun

let drop = Droplet()
try drop.addProvider(Mail.Provider<MailgunClient>.self)
```

SendGrid expects a configuration file named `mailgun.json` with the following
format, and will throw `.noMailgunConfig` or `.missingConfig(fieldname)` if
configuration was not found.

```json
{
    "domain": "MG.YOUR_DOMAIN",
    "apiKey": "MG.YOUR_KEY"
}
```

Once installed, you can send simple emails using the following format:

```Swift
let email = Email(from: …, to: …, subject: …, body: …)
try drop.mailer?.send(email)
```

Mailgun supports both HTML and Plain Text emails.

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
