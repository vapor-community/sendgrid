import XCTest
import Mail
@testable import Vapor

private final class DummyMailClient: MailClientProtocol {
    var didSend = false

    init() throws {}

    func send(_ emails: [Mail.Email]) throws {
        didSend = true
    }

    func nativeSend(_ email: Mail.Email) throws {
        try send(email)
    }
}

class DropletTests: XCTestCase {
    static let allTests = [
        ("testSendEmail", testSendEmail),
        ("testSendNativeEmail", testSendNativeEmail),
    ]

    func testSendEmail() throws {
        let drop = try makeDroplet()
        drop.mailer = DummyMailClient.self
        let email = Email(from: "from@email.com",
                          to: "to1@email.com", "to2@email.com",
                          subject: "Email Subject",
                          body: "Hello Email")
        let attachment = EmailAttachment(filename: "dummy.data",
                                         contentType: "dummy/data",
                                         body: [1,2,3,4,5])
        email.attachments.append(attachment)
        try drop.mailer?.send(email)
        // XCTAssertTrue(dummyClient.didSend)
    }

    func testSendNativeEmail() throws {
        let drop = try makeDroplet()
        drop.mailer = DummyMailClient.self
        let email = Email(from: "from@email.com",
                          to: "to1@email.com", "to2@email.com",
                          subject: "Email Subject",
                          body: "Hello Email")
        let attachment = EmailAttachment(filename: "dummy.data",
                                         contentType: "dummy/data",
                                         body: [1,2,3,4,5])
        email.attachments.append(attachment)
        guard let dummyClient = try drop.mailer?.make() as? DummyMailClient else {
            XCTFail()
            return
        }
        try dummyClient.nativeSend(email)
        XCTAssertTrue(dummyClient.didSend)
    }

}

extension DropletTests {
    func makeDroplet() throws -> Droplet {
        let drop = Droplet(arguments: ["/dummy/path/", "prepare"])
        try drop.runCommands()
        return drop
    }
}