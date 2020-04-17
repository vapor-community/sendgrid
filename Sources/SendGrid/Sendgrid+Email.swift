import Vapor
import Email
import SendGridKit

extension SendGridClient: EmailClient {
    public func send(_ emails: [VaporEmail]) -> EventLoopFuture<Void> {
        self.send(emails: emails.map { convert($0) })
    }
    
    public func send(_ email: VaporEmail) -> EventLoopFuture<Void> {
        return self.send(email: convert(email))
    }
    
    private func convert(_ email: VaporEmail) -> SendGridEmail {
        let personalization = Personalization(
            to: email.to.sendgrid(),
            cc: email.cc?.sendgrid(),
            bcc: email.bcc?.sendgrid(),
            subject: email.subject
        )
        
        var content = [[
            "type": "text/plain",
            "value": email.text
            ]]
        
        if let html = email.html {
            content.append([
                "type": "text/html",
                "value": html
            ])
        }
        
        var sendgridEmail = SendGridEmail(
            personalizations: [personalization],
            from: .init(email: email.from.email, name: email.from.name),
            subject: email.subject,
            content: content,
            attachments: nil
        )
        
        if let replyTo = email.replyTo {
            sendgridEmail.replyTo = .init(email: replyTo.email, name: replyTo.name)
        }
        
        return sendgridEmail
    }
    
    public func delegating(to eventLoop: EventLoop) -> EmailClient {
        return self.hopped(to: eventLoop)
    }
}

extension Array where Element == Email.EmailAddress {
    func sendgrid() -> [SendGridKit.EmailAddress]? {
        guard !self.isEmpty else {
            return nil
        }
        
        return self.map {
            SendGridKit.EmailAddress(email: $0.email, name: $0.name)
        }
    }
}
