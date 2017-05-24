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

    public static func configure(_ config: Config) throws {}

    public static func boot(_ drop: Droplet) {}

    public init() {}

    public func send(_ emails: [Email]) throws {
        sentEmails += emails
    }

}
