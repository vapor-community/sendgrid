import Vapor

public final class Provider: Vapor.Provider {
    public static let repositoryName = "sendgrid-provider"
    
    public init(config: Config) throws { }
    
    
    public func boot(_ config: Config) throws {
        config.addConfigurable(mail: SendGrid.init, name: "sendgrid")
    }
    
    public func boot(_ drop: Droplet) throws { }
    public func beforeRun(_ drop: Droplet) {}
}
