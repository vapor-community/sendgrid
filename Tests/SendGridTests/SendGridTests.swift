import SendGrid
import Testing
import XCTVapor

struct SendGridTests {
    @Test func application() async throws {
        try await withApp { app in
            // TODO: Replace from addresses and to addresses
            let email = SendGridEmail(
                personalizations: [Personalization(to: ["TO-ADDRESS"])],
                from: "FROM-ADDRESS",
                subject: "Test Email",
                content: ["This email was sent using SendGridKit!"]
            )

            try await withKnownIssue {
                try await app.sendgrid.client.send(email: email)
            } when: {
                // TODO: Replace with `false` when you have a valid API key
                true
            }
        }
    }

    @Test func request() async throws {
        try await withApp { app in
            app.get("test") { req async throws -> Response in
                // TODO: Replace from addresses and to addresses
                let email = SendGridEmail(
                    personalizations: [Personalization(to: ["TO-ADDRESS"])],
                    from: "FROM-ADDRESS",
                    subject: "Test Email",
                    content: ["This email was sent using SendGridKit!"]
                )
                try await req.sendgrid.client.send(email: email)
                return Response(status: .ok)
            }

            try await app.test(.GET, "test") { res async throws in
                // TODO: Replace with `.ok` when you have a valid API key
                #expect(res.status == .internalServerError)
            }
        }
    }

    @Test func storage() async throws {
        try await withApp { app in
            // TODO: Replace from addresses and to addresses
            let email = SendGridEmail(
                personalizations: [Personalization(to: ["TO-ADDRESS"])],
                from: "FROM-ADDRESS",
                subject: "Test Email",
                content: ["This email was sent using SendGridKit!"]
            )

            do {
                try await app.sendgrid.client.send(email: email)
            } catch {}
            
            // Try sending again to ensure the client is stored and reused
            // You'll see if it's reused in the code coverage report
            do {
                try await app.sendgrid.client.send(email: email)
            } catch {}
        }
    }
}
