import HTTP
import Mail
import SMTP
import Vapor
import Foundation

/**
    SendGrid client
*/
public final class MailClient {

    static let apiKey: String
    static let client: ClientProtocol

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
        self.apiKey = apiKey
    }

    public init(clientProtocol: ClientProtocol.Type, apiKey: String) throws {
        MailClient.apiKey = apiKey
        client = try clientProtocol.make(scheme: "https", host: "api.sendgrid.com")
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


extension MailClient: MailClientProtocol {

  public convenience init() throws {
      guard let clientProtocol = Provider.clientProtocol else {
          throw Provider.Error.noClient
      }
      guard let apiKey = Provider.apiKey else {
          throw Provider.Error.missingConfig("apiKey")
      }
      try self.init(clientProtocol: clientProtocol, apiKey: apiKey)
  }

  public func send(_ emails: [SMTP.Email]) throws {
      // Convert to SendGrid Emails and then send
      let sgEmails = emails.map { SendGridEmail(from: $0 ) }
      try send(sgEmails)
  }

}
