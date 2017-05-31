import SMTP
import Vapor

/**
    A development-only MailClient which does not send emails; rather, it
    stores them in the `sentEmails` property for debugging purposes.
*/
public final class InMemoryMailClient: MailProtocol {

    /**
        Every email 'sent' by this client is stored in this array.
    */
    public private(set) var sentEmails: [Email] = []

    public init() {}

    public func send(_ emails: [Email]) throws {
        sentEmails += emails
    }

}

extension InMemoryMailClient: ConfigInitializable {
    public convenience init(config: Config) throws {
        self.init()
    }
}
