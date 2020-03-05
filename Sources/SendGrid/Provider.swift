import Vapor

extension Application {
    public var sendgridClient: SendGridClient {
        .init(application: self)
    }
}
