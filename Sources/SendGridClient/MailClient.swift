import HTTP
import Mail

/**
    SendGrid client
*/
public final class MailClient: MailClientProtocol {

    let apiKey: String
    let client: ClientProtocol

    public convenience init() throws {
        guard let clientProtocol = Provider.clientProtocol else {
            throw Provider.Error.noClient
        }
        guard let apiKey = Provider.apiKey else {
            throw Provider.Error.missingConfig("apiKey")
        }
        try self.init(clientProtocol: clientProtocol, apiKey: apiKey)
    }

    public init(clientProtocol: ClientProtocol.Type, apiKey: String) throws {
        self.apiKey = apiKey
        client = try clientProtocol.make(scheme: "https", host: "api.sendgrid.com")
    }

    public func send(_ emails: [Mail.Email]) throws {
        // Convert to SendGrid Emails and then send
        let sgEmails = emails.map { Email(from: $0 ) }
        try send(sgEmails)
    }

    public func send(_ emails: [Email]) throws {
        emails.forEach { email in
            // use the client to send off each email as JSON
        }
    }

}
