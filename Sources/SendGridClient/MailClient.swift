import HTTP
import Mail
import SMTP
import Vapor
import Foundation

/**
    SendGrid client
*/
public final class SendGridClient: MailClientProtocol {

    static var defaultApiKey: String?
    static var defaultClient: ClientProtocol.Type?

    var apiKey: String
    var client: ClientProtocol

    public enum Error: Swift.Error {
        case noSendGridConfig
        case missingConfig(String)
        case noClient
    }

    public static func configure(_ config: Settings.Config) throws {
        guard let sg = config["sendgrid"]?.object else {
            throw Error.noSendGridConfig
        }
        guard let apiKey = sg["apiKey"]?.string else {
            throw Error.missingConfig("apiKey")
        }
        defaultApiKey = apiKey
    }

    public static func boot(_ drop: Vapor.Droplet) {
        defaultClient = drop.client
    }

    public convenience init() throws {
        guard let client = SendGridClient.defaultClient else {
            throw Error.noClient
        }
        guard let apiKey = SendGridClient.defaultApiKey else {
            throw Error.missingConfig("apiKey")
        }
        try self.init(clientProtocol: client, apiKey: apiKey)
    }

    public init(clientProtocol: ClientProtocol.Type, apiKey: String) throws {
        self.apiKey = apiKey
        client = try clientProtocol.make(scheme: "https", host: "api.sendgrid.com")
    }

    public func send(_ emails: [SMTP.Email]) throws {
        // Convert to SendGrid Emails and then send
        let sgEmails = emails.map { SendGridEmail(from: $0 ) }
        try send(sgEmails)
    }

    public func send(_ emails: [SendGridEmail]) throws {
        let headers: [HeaderKey: String] = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]

        try emails.forEach { email in
            let jsonData = try JSONSerialization.data(withJSONObject: email.toDictionary(), options: .prettyPrinted)
            do {
                let test = try client.post(path: "/v3/mail/send", headers: headers, body: Body(jsonData))
                if(test.status.statusCode != 200 && test.status.statusCode != 202){
                    let sendgridErrors: [SendgridError] = try test.json!.extract("errors")
                    throw Abort.custom(status: test.status, message: sendgridErrors[0].message)
                }
            } catch let error {
                throw error
            }
        }
    }

}
