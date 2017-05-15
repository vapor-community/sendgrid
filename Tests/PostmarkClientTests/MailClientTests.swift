import XCTest
import Mail
import PostmarkClient
import HTTP
import Transport
import Vapor

class MailClientTests: XCTestCase {
    static let allTests = [
        ("testSendEmail", testSendEmail),
    ]
    
    let testServerToken = "POSTMARK_API_TEST"
    
    func testSendEmail() throws {
        let drop = Droplet()
        let mailer = try PostmarkClient.MailClient(clientProtocol: drop.client.self, serverToken: testServerToken)
        let email = Email(from: "from@email.com",
                          to: "to1@email.com", "to2@email.com",
                          subject: "Email Subject",
                          body: "Hello Email")
        try mailer.send(email)
        
        XCTAssertNotNil(mailer.result)
        XCTAssertEqual(mailer.result!.status, Status.ok)
    }
}
