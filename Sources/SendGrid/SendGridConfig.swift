import Vapor

public struct SendGridConfig {
    let apiKey: String
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
}
