import Mail
import Foundation

public final class Email {

    /*
        Array of personalization 'envelopes' for this email.

        See https://sendgrid.com/docs/Classroom/Send/v3_Mail_Send/personalizations.html
    */
    public var personalizations: [Personalization]
    /*
        Email sender address
    */
    public let from: EmailAddress
    /*
        If set, the first 'personalization' will be sent BCC to this address
    */
    public let bccFirst: EmailAddress?
    /*
        Email reply-to address
    */
    public let replyTo: EmailAddress?
    /*
        Email subject, which can be overwritten by each personalization
    */
    public let subject: String
    /*
        Email body content. Can only be nil if `templateId` is set
    */
    public var content: [EmailBody]?
    /*
        Set of attachments to this email
    */
    public var attachments: [EmailAttachmentRepresentable]
    /*
        ID of a predefined template to use
    */
    public let templateId: String?
    /*
        An object of key/value pairs that define large blocks of content that
        can be inserted into your emails using substitution tags.
    */
    public var sections: [String: String]
    /*
        Custom email headers
    */
    public var headers: [String: String]
    /*
        Category names for email, max 10
    */
    public var categories: [String]
    /*
        Date to send the email, or `nil` if email to be sent immediately
    */
    public let sendAt: Date?
    /*
        Include this email in a named batch
    */
    public let batchId: String?
    /*
        Determines how to handle unsubscribe links
    */
    public let unsubscribeHandling: UnsubscribeHandling
    /*
        IP pool to send from
    */
    public let ipPoolName: String?
    /*
        Bypass unsubscriptions and suppressions - use only in emergency
    */
    public let bypassListManagement: Bool
    /*
        Footer to add to email in variety of content types
    */
    public var footer: [Footer]?
    /*
        Send as test email
    */
    public var sandboxMode: Bool
    /*
        Enable spam testing
    */
    public var spamCheckMode: SpamCheck
    /*
        Set click tracking behaviour
    */
    public var clickTracking: ClickTracking
    /*
        Set open tracking behaviour
    */
    public var openTracking: OpenTracking
    /*
        Set behaviour of subscription management links
    */
    public var subscriptionManagement: SubscriptionManagement
    /*
        Set Google Analytics tracking
    */
    public var googleAnalytics: GoogleAnalytics

    // public init(templateId: String, ...) // using a template

    // public init(...) // body content

    // public init(from: Mail.Email) // convert from a basic Vapor Email
}
