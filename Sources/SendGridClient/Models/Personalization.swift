import Mail
import Foundation

public struct Personalization {

    /*
        The email recipients
    */
    let to: [EmailAddress]
    /*
        The email copy recipients
    */
    let cc: [EmailAddress]?
    /*
        The email blind copy recipients
    */
    let bcc: [EmailAddress]?
    /*
        The email subject, overriding that of the Email, if set
    */
    let subject: String?
    /*
        Custom headers
    */
    let headers: [String: String]?
    /*
        Custom substitutions in the format ["tag": "value"]
    */
    let substitutions: [String: String]?
    /*
        Date to send the email, or `nil` if email to be sent immediately
    */
    let sendAt: Date?

}
