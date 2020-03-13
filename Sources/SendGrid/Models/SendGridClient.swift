import Vapor

public final class SendGridClient {
    let httpClient: Client
    let apiKey: String
    let apiEndpoint: URI = URI(string: "https://api.sendgrid.com/v3/mail/send")

    public init(client: Client, apiKey: String) {
        self.httpClient = client
        self.apiKey = apiKey
    }
    
    public func send(_ emails: [SendGridEmail], on eventLoop: EventLoop) throws -> EventLoopFuture<Void> {
        
        return emails.map { email in
            
            var headers = HTTPHeaders()
            headers.add(name: .contentType, value: "application/json")
            headers.add(name: .authorization, value: "Bearer \(apiKey)")
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .secondsSince1970

            let request = httpClient.post(apiEndpoint, headers: headers) {
                try $0.content.encode(email, using: encoder)
            }
            
            return request.flatMap { response in
                switch response.status {
                case .ok, .accepted:
                    return eventLoop.makeSucceededFuture(())
                default:
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    do {
                        let error = try response.content.decode(SendGridError.self)
                        return eventLoop.makeFailedFuture(error)
                    } catch  {
                        return eventLoop.makeFailedFuture(error)
                    }
                }
            }
        }.flatten(on: eventLoop)
    }
}
