import Foundation
import SMTP

public struct Personalization {

    /*
        The email recipients
    */
    public let to: [EmailAddress]
    /*
        The email copy recipients
    */
    public let cc: [EmailAddress] = []
    /*
        The email blind copy recipients
    */
    public let bcc: [EmailAddress] = []
    /*
        The email subject, overriding that of the Email, if set
    */
    public let subject: String? = nil
    /*
        Custom headers
    */
    public let headers: [String: String] = [:]
    /*
        Custom substitutions in the format ["tag": "value"]
    */
    public let substitutions: [String: String] = [:]
    /*
        Date to send the email, or `nil` if email to be sent immediately
    */
    public let sendAt: Date? = nil

    public init(to: [EmailAddress]) {
        self.to = to
    }

}
