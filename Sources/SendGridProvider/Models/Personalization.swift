import Foundation
import SMTP
import Vapor

public struct Personalization {

    /*
        The email recipients
    */
    public let to: [EmailAddress]
    /*
        The email copy recipients
    */
    public let cc: [EmailAddress]
    /*
        The email blind copy recipients
    */
    public let bcc: [EmailAddress]
    /*
        The email subject, overriding that of the Email, if set
    */
    public let subject: String?
    /*
        Custom headers
    */
    public var headers: [String: String] = [:]
    /*
        Custom substitutions in the format ["tag": "value"]
    */
    public var substitutions: [String: String] = [:]
    /*
        Date to send the email, or `nil` if email to be sent immediately
    */
    public var sendAt: Date? = nil

    public init(to: [EmailAddress], cc: [EmailAddress], bcc: [EmailAddress], subject: String?) {
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.subject = subject
    }

    public init(to: [EmailAddress]) {
        self.init(to: to, cc: [], bcc: [], subject: nil)
    }

}
