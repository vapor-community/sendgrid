import XCTest
import Mail
import SMTP
import SendGrid
@testable import Vapor

// Test inbox: https://www.mailinator.com/inbox2.jsp?public_to=bygri-mail

class SendGridClientTests: XCTestCase {
    static let allTests = [
        ("testProvider", testProvider),
    ]

    let apiKey = "SG.YOUR_KEY" // Set here, but don't commit to git!

    func testProvider() throws {
        if apiKey == "SG.YOUR_KEY" {
            print("Not testing SendGrid as no API Key is set")
            return
        }
        let config = Config([
            "sendgrid": [
                "apiKey": Node(apiKey)
            ],
        ])
        let drop = try makeDroplet(config: config)
        try drop.addProvider(Mail.Provider<SendGridClient>.self)

        let email = SMTP.Email(from: "bygri-mail-from@mailinator.com",
                          to: "bygri-mail@mailinator.com",
                          subject: "Email Subject",
                          body: "Hello Email")
        let attachment = EmailAttachment(filename: "dummy.data",
                                         contentType: "dummy/data",
                                         body: [1,2,3,4,5])
        email.attachments.append(attachment)
        try drop.mailer?.send(email)
    }

}

extension SendGridClientTests {
    func makeDroplet(config: Config? = nil) throws -> Droplet {
        let drop = Droplet(arguments: ["/dummy/path/", "prepare"], config: config)
        try drop.runCommands()
        return drop
    }
}
