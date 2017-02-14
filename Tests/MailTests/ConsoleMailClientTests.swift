import XCTest
@testable import Mail
import SMTP
@testable import Vapor

class ConsoleMailClientTests: XCTestCase {
    static let allTests = [
        ("testSendEmail", testSendEmail),
        ("testSendMultipleEmails", testSendMultipleEmails),
        ("testProvider", testProvider),
    ]

    func testSendEmail() throws {
        let mailer = ConsoleMailClient()
        let email = SMTP.Email(from: "from@email.com",
                          to: "to1@email.com", "to2@email.com",
                          subject: "Email Subject",
                          body: "Hello Email")
        let attachment = EmailAttachment(filename: "dummy.data",
                                         contentType: "dummy/data",
                                         body: [1,2,3,4,5])
        email.attachments.append(attachment)
        try mailer.send(email)
    }

    func testSendMultipleEmails() throws {
        let mailer = ConsoleMailClient()
        let emails = [
            SMTP.Email(from: "from@email.com", to: "to@email.com", subject: "Email1", body: "Email1 body"),
            SMTP.Email(from: "from@email.com", to: "to@email.com", subject: "Email2", body: "Email2 body"),
            SMTP.Email(from: "from@email.com", to: "to@email.com", subject: "Email3", body: "Email3 body"),
        ]
        try mailer.send(emails)
    }

    func testProvider() throws {
        let drop = try makeDroplet()
        try drop.addProvider(Mail.Provider<ConsoleMailClient>.self)

        let email = SMTP.Email(from: "from@email.com",
                          to: "to1@email.com", "to2@email.com",
                          subject: "Email Subject",
                          body: "Hello Email")
        let attachment = EmailAttachment(filename: "dummy.data",
                                         contentType: "dummy/data",
                                         body: [1,2,3,4,5])
        email.attachments.append(attachment)
        try drop.mailer?.send(email)
    }

}

extension ConsoleMailClientTests {
    func makeDroplet() throws -> Droplet {
        let drop = Droplet(arguments: ["/dummy/path/", "prepare"])
        try drop.runCommands()
        return drop
    }
}
