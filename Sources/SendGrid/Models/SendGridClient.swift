import Vapor

public final class SendGridStatus {
    public var success: Bool
    public var email: SendGridEmail
    public var error: SendGridError?
    
    init(_ success: Bool, _ email: SendGridEmail, _ error: SendGridError? = nil) {
        self.success = success
        self.email = email
        self.error = error
    }
}

public final class SendGridClient {
    let httpClient: Client
    let apiKey: String
    let apiEndpoint:URI = URI(string: "https://api.sendgrid.com/v3/mail/send")

    public init(client: Client, apiKey: String) {
        self.httpClient = client
        self.apiKey = apiKey
    }
    
    public func send(_ emails: [SendGridEmail], on eventLoop: EventLoop) -> EventLoopFuture<[SendGridStatus]> {
        
        return emails.map { (email) in
            
            var headers: HTTPHeaders = [:]
            headers.add(name: .contentType, value: "application/json")
            headers.add(name: .authorization, value: "Bearer \(apiKey)")
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .secondsSince1970

            let sgRequest = httpClient.post(apiEndpoint, headers: headers, beforeSend: { req in
                try req.content.encode(email, using: encoder)
            })
            
            return sgRequest.map { response in
                switch response.status {
                case .ok, .accepted: return SendGridStatus(true, email)
                default:
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    do {
                        let error = try response.content.decode(SendGridError.self)
                        return SendGridStatus(false, email, error)
                    }
                    catch {
                        return SendGridStatus(false, email)
                    }
                }
            }
        }.flatten(on: eventLoop )
    }
}
