import XCTest
@testable import Mail
import SMTP
@testable import Vapor

private final class DummyMailClient: MailClientProtocol {

    enum Error: Swift.Error {
        case noConfiguration
        case missingConfiguration(String)
    }

    static var configurationString = "not configured"

    var didSend = false

    static func configure(_ config: Config) throws {
        guard let c = config["dummy"]?.object else {
            throw Error.noConfiguration
        }
        guard let string = c["string"]?.string else {
            throw Error.missingConfiguration("string")
        }
        configurationString = string
    }

    public static func boot(_ drop: Droplet) {}

    init() throws {}

    func send(_ emails: [SMTP.Email]) throws {
        didSend = true
    }

    func nativeSend(_ email: SMTP.Email) throws {
        try send(email)
    }
}

class DropletTests: XCTestCase {
    static let allTests = [
        ("testSendEmail", testSendEmail),
        ("testSendNativeEmail", testSendNativeEmail),
        ("testProvider", testProvider),
        ("testViewEmail", testViewEmail),
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

    func testProvider() throws {
        let config = Config([
            "dummy": [
                "string": "configured"
            ],
        ])
        let drop = try makeDroplet(config: config)
        try drop.addProvider(Mail.Provider<DummyMailClient>.self)
        XCTAssertEqual(DummyMailClient.configurationString, "configured")
    }

    func testViewEmail() throws {
        let drop = try makeDroplet()
        drop.view = TestRenderer(viewsDir: "neverland")
        drop.mailer = DummyMailClient.self
        let email = try Email(from: "from@email.com",
                              to: "to1@email.com", "to2@email.com",
                              subject: "Email Subject",
                              body: EmailBody(drop, type: .html, view: "email", [
                                  "name": "Peter Pan",
                              ]))
        XCTAssertEqual(email.body.content, "object([\"name\": Node.Node.string(\"Peter Pan\")])")
        try drop.mailer?.send(email)
    }

}

extension DropletTests {
    func makeDroplet(config: Config? = nil) throws -> Droplet {
        let drop = Droplet(arguments: ["/dummy/path/", "prepare"], config: config)
        try drop.runCommands()
        return drop
    }
}
