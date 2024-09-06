import XCTVapor
import SendGrid

class SendGridTests: XCTestCase {    
    var app: Application!
    // TODO: Replace from addresses and to addresses
    let email = SendGridEmail(
        personalizations: [Personalization(to: ["TO-ADDRESS"])],
        from: "FROM-ADDRESS",
        subject: "Test Email",
        content: ["This email was sent using SendGridKit!"]
    )

    override func setUp() async throws {
        self.app = try await Application.make(.testing)
    }

    override func tearDown() async throws {
        try await app.asyncShutdown()
    }

    func testApplication() async throws {
        do {
            try await app.sendgrid.client.send(email: email)
        } catch {}
    }

    func testRequest() async throws {
        app.get("test") { req async throws -> Response in
            try await req.sendgrid.client.send(email: self.email)
            return Response(status: .ok)
        }

        try await app.test(.GET, "test") { res async throws in
            XCTAssertEqual(res.status, .internalServerError)
        }
    }
}
