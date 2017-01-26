import Foundation
import Mail

public class SendGridEmail {

    /*
        Array of personalization 'envelopes' for this email.

        See https://sendgrid.com/docs/Classroom/Send/v3_Mail_Send/personalizations.html
    */
    public var personalizations: [Personalization] = []
    /*
        Email sender address
    */
    public let from: EmailAddress
    /*
        If set, the first 'personalization' will be sent BCC to this address
    */
    public var bccFirst: EmailAddress? = nil
    /*
        Email reply-to address
    */
    public var replyTo: EmailAddress? = nil
    /*
        Email subject, which can be overwritten by each personalization
    */
    public let subject: String
    /*
        Set of attachments to this email
    */
    public var attachments: [EmailAttachmentRepresentable] = []
    /*
        An object of key/value pairs that define large blocks of content that
        can be inserted into your emails using substitution tags.
    */
    public var sections: [String: String] = [:]
    /*
        Custom email headers
    */
    public var headers: [String: String] = [:]
    /*
        Category names for email, max 10
    */
    public var categories: [String] = []
    /*
        Date to send the email, or `nil` if email to be sent immediately
    */
    public let sendAt: Date? = nil
    /*
        Include this email in a named batch
    */
    public let batchId: String? = nil
    /*
        Determines how to handle unsubscribe links
    */
    public let unsubscribeHandling: UnsubscribeHandling = .default
    /*
        IP pool to send from
    */
    public let ipPoolName: String? = nil
    /*
        Bypass unsubscriptions and suppressions - use only in emergency
    */
    public let bypassListManagement: Bool = false
    /*
        Footer to add to email in variety of content types
    */
    public var footer: [Footer] = []
    /*
        Send as test email
    */
    public var sandboxMode: Bool = false
    /*
        Enable spam testing
    */
    public var spamCheckMode: SpamCheck = .disabled
    /*
        Set click tracking behaviour
    */
    public var clickTracking: ClickTracking = .disabled
    /*
        Set open tracking behaviour
    */
    public var openTracking: OpenTracking = .disabled
    /*
        Set behaviour of subscription management links
    */
    public var subscriptionManagement: SubscriptionManagement = .disabled
    /*
        Set Google Analytics tracking
    */
    public var googleAnalytics: GoogleAnalytics? = nil

    // public init(from: EmailAddressRepresentable, to: EmailAddressRepresentable..., subject: String, body: EmailBodyRepresentable, attachments: [EmailAttachmentRepresentable] = []) {

    internal init(from: EmailAddressRepresentable, subject: String) {
        personalizations = []
        self.from = from.emailAddress
        self.subject = subject
        // TODO: ... complete.
    }

}

public final class TemplateEmail: SendGridEmail {
    /*
        ID of a predefined template to use
    */
    public let templateId: String

    public init(from: EmailAddressRepresentable, subject: String, templateId: String) {
        self.templateId = templateId
        super.init(from: from, subject: subject)
    }
}

public final class ContentEmail: SendGridEmail {
    /*
        Email body content. Can only be nil if `templateId` is set
    */
    public var content: [EmailBody]

    public init(from: EmailAddressRepresentable, subject: String, body: EmailBodyRepresentable) {
        content = [body.emailBody]
        super.init(from: from, subject: subject)
    }
}
