# Mail

![Swift](http://img.shields.io/badge/swift-3.0-brightgreen.svg)

Vapor Provider for sending email through swappable backends.

Backends included in this repository:

* `InMemoryMailClient`, a development-only backend which stores emails in memory.
* `ConsoleMailClient`, a development-only backend which outputs emails to the console.

## 📘 Overview

Simply add your choice of mail client provider to your Droplet, for access to
frictionless mail sending. If you use `drop.mailer` to send emails, you can
change the provider at any time without affecting your mailing code.

```Swift
let drop = Droplet()
try drop.addProvider(ConsoleMailClient.Provider.self)

let email = Email(from: "from@email.com",
                  to: "to1@email.com", "to2@email.com",
                  subject: "Email Subject",
                  body: "Hello Email")
email.attachments.append(attachment)
try drop.mailer?.send(email)
```

Individual backends directly implement any applicable extra features such as
variable authentication per send, or templated emails. To make use of these
features:

```Swift
if let complicatedMailer = drop.mailer as? ComplicatedMailClient {
    complicatedMailer.send(complicatedEmail)
}
```

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
