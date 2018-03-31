import Vapor

public struct SendGridConfig: Service {
    let apiKey: String
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
}

public final class SendGridProvider: Provider {
    public static let repositoryName = "sendgrid-provider"
    
    public init(){}

    public func boot(_ config: Config) throws {}
    
    public func didBoot(_ worker: Container) throws -> EventLoopFuture<Void> {
        return .done(on: worker)
    }

    public func register(_ services: inout Services) throws {
        services.register { (container) -> SendGridClient in
            let httpClient = try container.make(Client.self)
            let config = try container.make(SendGridConfig.self)
            return SendGridClient(client: httpClient, apiKey: config.apiKey)
        }
    }
}
