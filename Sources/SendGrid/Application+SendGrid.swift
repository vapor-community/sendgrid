import NIOConcurrencyHelpers
import SendGridKit
import Vapor

extension Application {
    public var sendgrid: SendGrid {
        .init(application: self)
    }

    public struct SendGrid: Sendable {
        private final class Storage: Sendable {
            private struct SendableBox: Sendable {
                var client: SendGridClient
            }

            private let sendableBox: NIOLockedValueBox<SendableBox>

            var client: SendGridClient {
                get {
                    self.sendableBox.withLockedValue { box in
                        box.client
                    }
                }
                set {
                    self.sendableBox.withLockedValue { box in
                        box.client = newValue
                    }
                }
            }

            init(httpClient: HTTPClient, apiKey: String) {
                let box = SendableBox(client: .init(httpClient: httpClient, apiKey: apiKey))
                self.sendableBox = .init(box)
            }
        }

        private struct Key: StorageKey {
            typealias Value = Storage
        }

        fileprivate let application: Application

        public init(application: Application) {
            self.application = application
        }

        public var client: SendGridClient {
            get { self.storage.client }
            set { self.storage.client = newValue }
        }

        private var storage: Storage {
            if let existing = self.application.storage[Key.self] {
                return existing
            } else {
                guard let apiKey = Environment.process.SENDGRID_API_KEY else {
                    fatalError("No SendGrid API key provided")
                }
                let new = Storage(httpClient: self.application.http.client.shared, apiKey: apiKey)
                self.application.storage[Key.self] = new
                return new
            }
        }
    }
}
