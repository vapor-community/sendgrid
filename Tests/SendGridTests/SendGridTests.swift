import SendGrid
import Testing
import VaporTesting

@Suite("SendGrid Tests")
struct SendGridTests {
    // TODO: Replace with `false` when you have a valid API key
    let credentialsAreInvalid = true

    // TODO: Replace from addresses and to addresses
    let email = SendGridEmail(
        personalizations: [Personalization(to: ["TO-ADDRESS"])],
        from: "FROM-ADDRESS",
        subject: "Test Email",
        content: ["This email was sent using SendGridKit!"]
    )

    @Test("Access client from Application")
    func application() async throws {
        try await withApp { app in
            try await withKnownIssue {
                try await app.sendgrid.client.send(email: email)
            } when: {
                credentialsAreInvalid
            }
        }
    }

    @Test("Access client from Request")
    func request() async throws {
        try await withApp { app in
            app.get("test") { req async throws -> Response in
                try await req.sendgrid.client.send(email: email)
                return Response(status: .ok)
            }

            try await app.test(.GET, "test") { res async throws in
                let internalServerError = res.status == .internalServerError
                let ok = res.status == .ok
                #expect(credentialsAreInvalid ? internalServerError : ok)
            }
        }
    }

    @Test("Client storage in Application")
    func storage() async throws {
        try await withApp { app in
            do {
                try await app.sendgrid.client.send(email: email)
            } catch {}

            // Try sending again to ensure the client is stored and reused
            // You'll see if it's reused in the code coverage report
            do {
                try await app.sendgrid.client.send(email: email)
            } catch {}

            // Change the client and try sending again
            app.sendgrid.client = .init(httpClient: app.http.client.shared, apiKey: "new-api-key")

            do {
                try await app.sendgrid.client.send(email: email)
            } catch {}
        }
    }
}
