import HTTP
import Mail
import SMTP
import Vapor
import Foundation
import TLS

/**
    SendGrid client
*/
public final class SendGridClient {

    static var defaultApiKey: String?
    static var defaultClientFactory: ClientFactory?

    var apiKey: String
    var client: ClientProtocol

    public init(clientFactoryProtocol: ClientFactory, apiKey: String) throws {
        self.apiKey = apiKey
        client = try clientFactoryProtocol.makeClient(
            hostname: "api.sendgrid.com",
            port: 443,
            securityLayer: .tls(TLS.Context(.client))
        )
    }

    public func send(_ emails: [SendGridEmail]) throws {
        try emails.forEach { email in
            let jsonBytes = try JSON(node: email.makeNode(in: nil)).makeBytes()
            // let request = Request(method: .post, uri: "")
            let response = try client.post("/v3/mail/send", headers: [
                "Authorization": "Bearer \(apiKey)",
                "Content-Type": "application/json"
            ], body: Body(jsonBytes))
            switch response.status.statusCode {
            case 200, 202:
                return
            case 400:
                throw SendGridError.badRequest(
                    try response.json?.extract("errors") ?? []
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

/*
extension SendGridClient: MailClientProtocol {

    public static func configure(_ config: Config) throws {
        guard let sg = config["sendgrid"]?.object else {
            throw ConfigError.missingFile("sendgrid")
        }
        guard let apiKey = sg["apiKey"]?.string else {
            throw ConfigError.missing(key: ["apiKey"], file: "sendgrid", desiredType: String.self)
        }
        defaultApiKey = apiKey
    }

    public static func boot(_ drop: Vapor.Droplet) {
        defaultClientFactory = drop.client
    }

    public convenience init() throws {
        guard let client = SendGridClient.defaultClient else {
            throw SendGridError.noClient
        }
        guard let apiKey = SendGridClient.defaultApiKey else {
            throw ConfigError.missing(key: ["apiKey"], file: "sendgrid", desiredType: String.self)
        }
        try self.init(clientFactoryProtocol: client, apiKey: apiKey)
    }

    public func send(_ emails: [SMTP.Email]) throws {
        // Convert to SendGrid Emails and then send
        let sgEmails = emails.map { SendGridEmail(from: $0 ) }
        try send(sgEmails)
    }

}
*/
