import SendGridKit
import Vapor

extension Request {
    public var sendgrid: Application.SendGrid {
        .init(application: self.application)
    }
}
