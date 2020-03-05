import Vapor

public struct SendGridClient {
    let application: Application

    public struct Configuration {
        public var apiKey: String = ""
        let apiEndpoint: URI = "https://api.sendgrid.com/v3/mail/send"
    }

    struct ConfigurationKey: StorageKey {
        typealias Value = Configuration
    }

    public var configuration: Configuration {
        get {
            application.storage[ConfigurationKey.self] ?? .init()
        }
        nonmutating set {
            self.application.storage[ConfigurationKey.self] = newValue
        }
    }

    public func send(_ emails: [SendGridEmail], on worker: EventLoopGroup) throws -> EventLoopFuture<Void> {
        return emails
            .map { email in
                var headers: HTTPHeaders = [:]
                headers.add(name: .contentType, value: HTTPMediaType.json.description)
                headers.add(name: .authorization, value: "Bearer \(configuration.apiKey)")

                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .secondsSince1970

                let request = application.client.post(configuration.apiEndpoint, headers: headers, beforeSend: { req in
                    try req.content.encode(email, using: encoder)
                })

                return request.flatMapThrowing { response in
                    switch response.status {
                        case .ok,
                             .accepted:
                            return

                        default:
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .secondsSince1970

                            let data: Data
                            if let bytesView = response.body?.readableBytesView {
                                data = Data(bytesView)
                            } else {
                                data = .init()
                            }

                            let error = try decoder.decode(SendGridError.self, from: data)

                            throw error
                    }
                }
            }
            .flatten(on: worker.next())
    }
}
