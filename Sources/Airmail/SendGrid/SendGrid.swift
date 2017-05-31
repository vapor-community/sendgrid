import HTTP
import SMTP
import Vapor

/**
    SendGrid client
*/
public final class SendGrid: MailProtocol {
    let clientFactory: ClientFactoryProtocol
    let apiKey: String

    public init(_ clientFactory: ClientFactoryProtocol, apiKey: String) throws {
        self.apiKey = apiKey
        self.clientFactory = clientFactory
    }

    /* Send simple Vapor emails */
    public func send(_ emails: [Email]) throws {
        // Convert to SendGrid Emails and then send
        let sgEmails = emails.map { SendGridEmail(from: $0 ) }
        try send(sgEmails)
    }

    /* Send complex SendGrid featured emails */
    public func send(_ emails: [SendGridEmail]) throws {
        try emails.forEach { email in
            let request = Request(
                method: .post,
                uri: "https://api.sendgrid.com/v3/mail/send",
                headers: [
                    "Authorization": "Bearer \(apiKey)",
                    "Content-Type": "application/json"
                ]
            )
            request.body = try Body(JSON(node: email.makeNode(in: nil)).makeBytes())
            let response = try clientFactory.respond(to: request)
            switch response.status.statusCode {
            case 200, 202:
                return
            case 400:
                throw SendGridError.badRequest(
                    try response.json?.get("errors") ?? []
                )
            case 401:
                throw SendGridError.unauthorized
            case 413:
                throw SendGridError.payloadTooLarge
            case 429:
                throw SendGridError.tooManyRequests
            case 500, 503:
                throw SendGridError.serverError
            default:
                throw SendGridError.unexpectedServerResponse
            }
        }
    }

}

extension SendGrid: ConfigInitializable {
    public convenience init(config: Config) throws {
        guard let sg = config["sendgrid"] else {
            throw ConfigError.missingFile("sendgrid")
        }
        guard let apiKey = sg["apiKey"]?.string else {
            throw ConfigError.missing(key: ["apiKey"], file: "sendgrid", desiredType: String.self)
        }
        let client = try config.resolveClient()
        try self.init(client, apiKey: apiKey)
    }
}
