import Vapor
import HTTP


public final class Provider: Vapor.Provider {
    
    static var serverToken: String?
    static var clientProtocol: ClientProtocol.Type?
    
    public enum Error: Swift.Error {
        case noPostmarkConfig
        case missingConfig(String)
        case noClient
    }
    
    public convenience init(config: Config) throws {
        guard let sg = config["postmark"]?.object else {
            throw Error.noPostmarkConfig
        }
        guard let serverToken = sg["serverToken"]?.string else {
            throw Error.missingConfig("serverToken")
        }
        try self.init(serverToken: serverToken)
    }
    
    public init(serverToken: String) throws {
        Provider.serverToken = serverToken
    }
    
    public func boot(_ drop: Droplet) {
        Provider.clientProtocol = drop.client
        // TODO: Uncomment when Droplet has `mailer` property.
        // if let existing = drop.mailer {
        //     print("PostmarkClient will overwrite existing mailer: \(type(of: existing))")
        // }
        // drop.mailer = MailClient.self
    }
    
    public func afterInit(_ drop: Droplet) {
        
    }
    
    public func beforeRun(_ drop: Droplet) {
        
    }
    
}
