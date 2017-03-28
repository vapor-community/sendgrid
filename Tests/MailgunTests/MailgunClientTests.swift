import XCTest
import Mail
import SMTP
import Mailgun
@testable import Vapor


class MailgunClientTests: XCTestCase {
    static let allTests = [
        ("testProvider", testProvider),
    ]

    let apiKey = "MG.YOUR_KE" // Set here, but don't commit to git!
    let domain = "MG.YOUR_DOMAIN" // Set here, but don't commit to git!

    func testProvider() throws {
        if apiKey == "MG.YOUR_KEY" {
            print("Not testing Mailgun as no API Key is set")
            return
        }
        if apiKey == "MG.YOUR_DOMAIN" {
            print("Not testing Mailgun as no domain is set")
            return
        }
        let config = Config([
            "mailgun": [
                "apiKey": Node(apiKey),
                "domain": Node(domain)
            ],
        ])
        let drop = try makeDroplet(config: config)
        try drop.addProvider(Mail.Provider<MailgunClient>.self)

        let email = SMTP.Email(from: "vapor-mail-from@mailinator.com",
                          to: "vapor-mail@mailinator.com",
                          subject: "Email Subject",
                          body: "Hello Email")
        try drop.mailer?.send(email)
    }

}

extension MailgunClientTests {
    func makeDroplet(config: Config? = nil) throws -> Droplet {
        let drop = Droplet(arguments: ["/dummy/path/", "prepare"], config: config)
        try drop.runCommands()
        return drop
    }
}
