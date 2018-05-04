import Vapor

public final class SendGridClient: Service {
    let httpClient: Client
    let apiKey: String
    let apiEndpoint = "https://api.sendgrid.com/v3/mail/send"

    public init(client: Client, apiKey: String) {
        self.httpClient = client
        self.apiKey = apiKey
    }
    
    public func send(_ emails: [SendGridEmail], on worker: Worker) throws -> Future<Void> {
        
        return emails.map { (email) in
            
            var headers: HTTPHeaders = [:]
            headers.add(name: .contentType, value: MediaType.json.description)
            headers.add(name: .authorization, value: "Bearer \(apiKey)")
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .secondsSince1970

            let request = httpClient.post(apiEndpoint, headers: headers, beforeSend: { req in
                try req.content.encode(json: email, using: encoder)
            })
            
            return request.map { response in
                switch response.http.status {
                case .ok, .accepted: return
                default:
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let error = try decoder.decode(SendGridError.self, from: response.http.body.data ??  Data())
                    
                    throw error
                }
            }
        }.flatten(on: worker)
    }
}
