import Foundation
import SMTP

public final class SendGridEmail {

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
        Email subject, which can be overwritten by each personalization,
        and is required unless every personalization has a subject set or
        the email uses a template with a subject already set
    */
    public let subject: String?
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

    /*
        ID of a predefined template to use
    */
    public let templateId: String?
    /*
        Email body content. Can only be empty if `templateId` is set
    */
    public var content: [EmailBody] = []


    private init(from: EmailAddressRepresentable, subject: String, templateId: String?, body: EmailBodyRepresentable?) {
        personalizations = []
        self.from = from.emailAddress
        self.subject = subject
        self.templateId = templateId
        if let body = body {
            self.content = [body.emailBody]
        }
    }

    /*
        Init from a template
    */
    public convenience init(from: EmailAddressRepresentable, subject: String, templateId: String, body: EmailBodyRepresentable?) {
        self.init(from: from, subject: subject, templateId: templateId, body: body)
    }

    /*
        Init from an email body
    */
    public convenience init(from: EmailAddressRepresentable, subject: String, body: EmailBodyRepresentable) {
        self.init(from: from, subject: subject, templateId: nil, body: body)
    }

    public func toDictionary() -> [String: Any] {
        var data = [String: Any]()

        /*
            Personalizations
         */
        var personalizationArray = [[String:Any]]()
        for personalization in personalizations {
            var personalizationsDictionary = [String: Any]()
            if(personalization.subject != nil) { personalizationsDictionary["subject"] = personalization.subject! }
            if(personalization.headers.count > 0) { personalizationsDictionary["headers"] = personalization.headers }
            if(personalization.substitutions.count > 0) { personalizationsDictionary["substitutions"] = personalization.substitutions }
            if(personalization.sendAt != nil) { personalizationsDictionary["send_at"] = sendAt!.timeIntervalSince1970 }

            if(personalization.to.count > 0){
                var toArray = [[String:Any]]()
                for to in personalization.to {
                    var toDictionary = [String: Any]()
                    toDictionary["email"] = to.address
                    if(to.name != nil) { toDictionary["name"] = to.name! }
                    toArray.append(toDictionary)
                }
                personalizationsDictionary["to"] = toArray
            }

            if(personalization.cc.count > 0){
                var ccArray = [[String:Any]]()
                for cc in personalization.cc {
                    var ccDictionary = [String: Any]()
                    ccDictionary["email"] = cc.address
                    if(cc.name != nil) { ccDictionary["name"] = cc.name! }
                    ccArray.append(ccDictionary)
                }
                personalizationsDictionary["cc"] = ccArray
            }

            if(personalization.bcc.count > 0){
                var bccArray = [[String:Any]]()
                for bcc in personalization.bcc {
                    var bccDictionary = [String: Any]()
                    bccDictionary["email"] = bcc.address
                    if(bcc.name != nil) { bccDictionary["name"] = bcc.name! }
                    bccArray.append(bccDictionary)
                }
                personalizationsDictionary["bcc"] = bccArray
            }
            personalizationArray.append(personalizationsDictionary)
        }
        data["personalizations"] = personalizationArray

        /*
            From
         */
        var fromDictionary = [String: Any]()
        fromDictionary["email"] = from.address
        if(from.name != nil) { fromDictionary["name"] = from.name! }
        data["from"] = fromDictionary

        /*
            Reply To
         */
        if(replyTo != nil){
            var replyToDictionary = [String: Any]()
            replyToDictionary["email"] = replyTo!.address
            if(replyTo!.name != nil) { replyToDictionary["name"] = from.name! }
            data["reply_to"] = replyToDictionary
        }

        /*
            Subject
         */
        if(subject != "") { data["subject"] = subject }

        /*
            Content
         */
        if(content.count > 0) {
            var contentArray = [[String:Any]]()
            for cont in content {
                switch cont.type {
                case .html:
                    contentArray.append(["type": "text/html", "value": cont.content])
                case .plain:
                    contentArray.append(["type": "text/plain", "value": cont.content])
                }
            }
            data["content"] = contentArray
        }

        /*
            Attachments
         */
        if(attachments.count > 0) {
            var attachmentsArray = [[String:Any]]()
            for attachment in attachments {
                attachmentsArray.append([
                    "filename": attachment.emailAttachment.filename,
                    "content": attachment.emailAttachment.body,
                    "type": attachment.emailAttachment.contentType
                    ])
            }
            data["attachments"] = attachmentsArray
        }

        /*
            Template Id
         */
        if(templateId != nil) { data["template_id"] = templateId! }

        /*
            Sections
         */
        if(sections.count > 0) { data["sections"] = sections }

        /*
            Headers
         */
        if(headers.count > 0) { data["headers"] = headers }

        /*
            Categories
         */
        if(categories.count > 0) { data["categories"] = categories }

        /*
            Send At
         */
        if(sendAt != nil) { data["send_at"] = sendAt!.timeIntervalSince1970 }

        /*
            Batch Id
         */
        if(batchId != nil) { data["batch_id"] = batchId! }

        /*
            Unsubscribers
         */
        switch unsubscribeHandling {
        case let .usingGroupId(groupId, groups):
            data["asm"] = ["group_id": groupId, "groups_to_display": groups]
        default:
            break
        }

        /*
            Ip Pool Name
         */
        if(ipPoolName != nil) { data["ip_pool_name"] = ipPoolName! }

        /*
            Mail Settings
         */
        var mailSettings = [String: Any]()

        /*
                BCC
         */
        if(bccFirst != nil){
            mailSettings["bcc"] = ["email": bccFirst!.address, "enable": true]
        }

        /*
                Bypass List Management
         */
        if(bypassListManagement) {
            mailSettings["bypass_list_management"] = ["enable": true]
        }

        /*
                Footer
         */
        if(footer.count > 0) {
            var footerDictionary = [String: Any]()
            footerDictionary["enable"] = true
            for foot in footer {
                switch foot.type {
                case .html:
                    footerDictionary["html"] = foot.content
                case .plain:
                    footerDictionary["text"] = foot.content
                }
            }
            mailSettings["footer"] = footerDictionary
        }

        /*
                Sandbox Mode
         */
        if(sandboxMode) { mailSettings["sandbox_mode"] = ["enable": sandboxMode] }

        /*
                Spam Check
         */
        switch spamCheckMode {
        case let .enabled(threshold, url):
            mailSettings["spam_check"] = ["threshold": threshold, "post_to_url": url, "enable": true]
        default:
            break
        }
        if (mailSettings.count > 0) { data["mail_settings"] = mailSettings }

        /*
            Tracking Settings
         */
        var trackingSettings = [String: Any]()

        /*
                Click Tracking
         */
        if(clickTracking == ClickTracking.enabled) {
            trackingSettings["click_tracking"] = ["enable": true, "enable_text": true]
        } else if(clickTracking == ClickTracking.htmlOnly) {
            trackingSettings["click_tracking"] = ["enable": true, "enable_text": false]
        }

        /*
                Open Tracking
         */
        switch openTracking {
        case let .enabled(substitutionTag):
            trackingSettings["open_tracking"] = ["substitution_tag": substitutionTag!, "enable": true]
        default:
            break
        }

        /*
                Subscription Tracking
         */
        switch subscriptionManagement {
        case let .appending(text, html):
            if(text != nil) { trackingSettings["subscription_tracking"] = ["text": text!, "enable": true] }
            if(html != nil) { trackingSettings["subscription_tracking"] = ["html": html!, "enable": true] }
        case let .enabled(replacingTag):
            trackingSettings["subscription_tracking"] = ["substitution_tag": replacingTag, "enable": true]
        default:
            break
        }

        /*
                Google Analytics
         */
        if(googleAnalytics != nil) {
            var gaData = [String: Any]()
            if(googleAnalytics!.source != nil) { gaData["utm_source"] = googleAnalytics!.source! }
            if(googleAnalytics!.medium != nil) { gaData["utm_medium"] = googleAnalytics!.medium! }
            if(googleAnalytics!.term != nil) { gaData["utm_term"] = googleAnalytics!.term! }
            if(googleAnalytics!.content != nil) { gaData["utm_content"] = googleAnalytics!.content! }
            if(googleAnalytics!.campaign != nil) { gaData["utm_campaign"] = googleAnalytics!.campaign! }
            trackingSettings["ganalytics"] = gaData
        }
        if(trackingSettings.count > 0) { data["tracking_settings"] = trackingSettings }

        return data
    }
}
