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
        
        return try emails.map { (email) in
            
            var headers: HTTPHeaders = [:]
            headers.add(name: .contentType, value: MediaType.json.description)
            headers.add(name: .authorization, value: "Bearer \(apiKey)")
            
            let encoder = JSONEncoder()
            
            encoder.dateEncodingStrategy = .secondsSince1970
            
            let body = try encoder.encodeBody(from: email)
            
            let request = HTTPRequest(method: .POST, url: URL(string: apiEndpoint) ?? .root, headers: headers, body: body)
            
            return try httpClient.respond(to: Request(http: request, using: httpClient.container)).map(to: Void.self, { (response) -> (Void) in
                
                switch response.http.status {
                case .ok, .accepted: return
                default:
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let error = try decoder.decode(SendGridError.self, from: response.http.body.data ??  Data())
                    
                    throw error
                }
            })
        }.flatten(on: worker)
    }
}
