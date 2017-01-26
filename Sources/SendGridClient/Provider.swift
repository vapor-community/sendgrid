import Vapor
import HTTP

/*
    Configure SendGrid using a config file named `sendgrid.json` in the following
    format. You may want to put this in the Secrets/ folder.

        {
            "apiKey": "xxx"
        }
*/
public final class Provider: Vapor.Provider {

    static var apiKey: String?
    static var clientProtocol: ClientProtocol.Type?

    public enum Error: Swift.Error {
        case noSendGridConfig
        case missingConfig(String)
        case noClient
    }

    public convenience init(config: Config) throws {
        guard let sg = config["sendgrid"]?.object else {
            throw Error.noSendGridConfig
        }
        guard let apiKey = sg["apiKey"]?.string else {
            throw Error.missingConfig("apiKey")
        }
        try self.init(apiKey: apiKey)
    }

    public init(apiKey: String) throws {
        Provider.apiKey = apiKey
    }

    public func boot(_ drop: Droplet) {
        Provider.clientProtocol = drop.client
        // TODO: Uncomment when Droplet has `mailer` property.
        // if let existing = drop.mailer {
        //     print("SendGridMailClient will overwrite existing mailer: \(type(of: existing))")
        // }
        // drop.mailer = MailClient.self
    }

    public func afterInit(_ drop: Droplet) {

    }

    public func beforeRun(_ drop: Droplet) {

    }

}
