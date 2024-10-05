import SendGridKit
import Vapor

extension Request {
    public var sendgrid: Application.Sendgrid {
        .init(application: self.application)
    }
}
