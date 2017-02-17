import XCTest
import Mail
import SMTP
import SMTPClient
@testable import Vapor
import Transport

// Test inbox: https://www.mailinator.com/inbox2.jsp?public_to=bygri-mail

class SMTPClientTests: XCTestCase {
    static let allTests = [
        ("testProvider", testProvider),
    ]

    let username = "username" // Set here, but don't commit to git!
    let password = "password"
    let host = "host"
    let port = 0
    let securityLayer: SecurityLayer = .tls(nil)

    func testProvider() throws {
        if username == "username" && password == "password" && host == "host" && port == 0 {
            print("Not testing SMTP as no configuration is set")
            return
        }
        let config = Settings.Config([
            "smtp": [
                "username": Node(username),
                "password": Node(password),
                "host": Node(host),
                "port": Node(port),
            ],
        ])
        let drop = try makeDroplet(config: config)
        SMTPClient<TCPClientStream>.setSecurityLayer(.tls(nil))
        try drop.addProvider(Mail.Provider<SMTPClient<TCPClientStream>>.self)

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

extension SMTPClientTests {
    func makeDroplet(config: Settings.Config? = nil) throws -> Droplet {
        let drop = Droplet(arguments: ["/dummy/path/", "prepare"], config: config)
        try drop.runCommands()
        return drop
    }
}
