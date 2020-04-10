import Vapor
import SendGridKit

extension Application {
    public struct Sendgrid {
        private final class Storage {
            let apiKey: String
            
            init(apiKey: String) {
                self.apiKey = apiKey
            }
        }

        private struct Key: StorageKey {
            typealias Value = Storage
        }

        private var storage: Storage {
            if self.application.storage[Key.self] == nil {
                self.initialize()
            }
            return self.application.storage[Key.self]!
        }
        
        public func initialize() {
            guard let apiKey = Environment.process.SENDGRID_API_KEY else {
                fatalError("No sendgrid API key provided")
            }
            
            self.application.storage[Key.self] = .init(apiKey: apiKey)
        }

        fileprivate let application: Application

        public var client: SendGridClient {
            .init(httpClient: self.application.http.client.shared, apiKey: self.storage.apiKey)
        }
    }

    public var sendgrid: Sendgrid { .init(application: self) }
}

