import XCTest
import Mail
import SMTP
import SendGridClient
@testable import Vapor

class SendGridClientTests: XCTestCase {
    static let allTests = [
        // ("testSendEmail", testSendEmail),
        // ("testSendMultipleEmails", testSendMultipleEmails),
        ("testProvider", testProvider),
    ]

/*
    func testSendEmail() throws {
        let mailer = SendGridClient()
        let email = SMTP.Email(from: "from@email.com",
                          to: "to1@email.com", "to2@email.com",
                          subject: "Email Subject",
                          body: "Hello Email")
        let attachment = EmailAttachment(filename: "dummy.data",
                                         contentType: "dummy/data",
                                         body: [1,2,3,4,5])
        email.attachments.append(attachment)
        try mailer.send(email)

        XCTAssert(mailer.sentEmails.count == 1)
        XCTAssert(mailer.sentEmails[0].subject == "Email Subject")
    }
*/
/*
    func testSendMultipleEmails() throws {
        let mailer = SendGridClient()
        let emails = [
            SMTP.Email(from: "from@email.com", to: "to@email.com", subject: "Email1", body: "Email1 body"),
            SMTP.Email(from: "from@email.com", to: "to@email.com", subject: "Email2", body: "Email2 body"),
            SMTP.Email(from: "from@email.com", to: "to@email.com", subject: "Email3", body: "Email3 body"),
        ]
        try mailer.send(emails)

        XCTAssert(mailer.sentEmails.count == 3)
        XCTAssert(mailer.sentEmails[0].subject == "Email1")
        XCTAssert(mailer.sentEmails[1].subject == "Email2")
        XCTAssert(mailer.sentEmails[2].subject == "Email3")
    }
*/

    func testProvider() throws {
        let config = Config([
            "sendgrid": [
                "apiKey": "configured"
            ],
        ])
        let drop = try makeDroplet(config: config)
        try drop.addProvider(Mail.Provider<SendGridClient>.self)

        let email = SMTP.Email(from: "bygri-mail-from@mailinator.com",
                          to: "bygri-mail@mailinator.com",
                          subject: "Email Subject",
                          body: "Hello Email")
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
