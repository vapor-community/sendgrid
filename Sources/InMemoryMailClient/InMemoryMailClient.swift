import Mail

/**
    A development-only MailClient which does not send emails; rather, it
    stores them in the `sentEmails` property for debugging purposes.
*/
public final class MailClient: MailClientProtocol {

    /**
        Every email 'sent' by this client is stored in this array.
    */
    public private(set) var sentEmails: [Email] = []

    public init() {}

    public func send(_ emails: [Email]) throws {
        sentEmails += emails
    }

}
