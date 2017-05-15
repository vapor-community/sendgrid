import HTTP
import Mail
import Vapor


public final class MailClient {
    
    let serverToken: String
    let client: ClientProtocol
    public var result : Response?
    
    public init(clientProtocol: ClientProtocol.Type, serverToken: String) throws {
        self.serverToken = serverToken
        client = try clientProtocol.make(scheme: "https", host: "api.postmarkapp.com")
    }
}

extension EmailAddress {
    var smtpLongFormatted: String {
        var formatted = ""
        
        if let name = self.name {
            formatted += name
            formatted += " "
        }
        formatted += "<\(address)>"
        return formatted
    }
}

extension Sequence where Iterator.Element == EmailAddress {
    var smtpLongFormatted: String {
        return self.map { $0.smtpLongFormatted } .joined(separator: ", ")
    }
}


extension MailClient: MailClientProtocol {
    
    public convenience init() throws {
        guard let clientProtocol = Provider.clientProtocol else {
            throw Provider.Error.noClient
        }
        guard let serverToken = Provider.serverToken else {
            throw Provider.Error.missingConfig("serverToken")
        }
        try self.init(clientProtocol: clientProtocol, serverToken: serverToken)
    }
    
    public func send(_ emails: [Mail.Email]) throws {
        
        try emails.forEach { email in

            let jsonEmail = JSON([
                "From": email.from.emailAddress.smtpLongFormatted.makeNode(),
                "To": email.to.smtpLongFormatted.makeNode(),
                "Subject": email.subject.makeNode(),
                "HtmlBody": email.body.content.makeNode(),
            ])
            
            let headers : [HeaderKey: String] = [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "X-Postmark-Server-Token": serverToken
            ]
            
            result = try client.post(
                path: "email",
                headers: headers,
                body: .data(jsonEmail.makeBytes())
            )
        }
    }
}
