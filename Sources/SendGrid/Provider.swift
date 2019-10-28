import Vapor

public struct SendGridConfig {
    let apiKey: String
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
}

public final class SendGridProvider: Provider {
    public func register(_ app: Application) {
        app.register(SendGridClient.self) { app in
            let config = app.make(SendGridConfig.self)
            return .init(client: app.make(), apiKey: config.apiKey)
        }
    }
    
    public static let repositoryName = "sendgrid-provider"
    
    public init(){}

}
