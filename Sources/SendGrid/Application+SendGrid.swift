import Vapor
import SendGridKit

extension Application {
    public struct Sendgrid {
        private final class Storage {
            let apiKey: String
            let sendgridClient: SendGridClient
            
            init(httpClient: HTTPClient, apiKey: String) {
                self.apiKey = apiKey
                self.sendgridClient = SendGridClient(httpClient: httpClient, apiKey: apiKey)
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
        
        private func initialize() {
            guard let apiKey = Environment.process.SENDGRID_API_KEY else {
                fatalError("No sendgrid API key provided")
            }
            
            self.application.storage[Key.self] = .init(httpClient: self.application.client.http, apiKey: apiKey)
        }

        fileprivate let application: Application


        public var client: SendGridClient { self.storage.sendgridClient }
        
    }

    public var sendgrid: Sendgrid { .init(application: self) }
}
