import Vapor

public struct SendGridEmail: Content {
    
    /// An array of messages and their metadata. Each object within personalizations can be thought of as an envelope - it defines who should receive an individual message and how that message should be handled.
    public var personalizations: [Personalization]?

    public var from: EmailAddress?

    public var replyTo: EmailAddress?

    /// The global, or “message level”, subject of your email. This may be overridden by personalizations[x].subject.
    public var subject: String?
    
    /// An array in which you may specify the content of your email.
    public var content: [[String: String]]?

    /// An array of objects in which you can specify any attachments you want to include.
    public var attachments: [EmailAttachment]?
    
    /// The id of a template that you would like to use. If you use a template that contains a subject and content (either text or html), you do not need to specify those at the personalizations nor message level.
    public var templateId: String?
    
    /// An object of key/value pairs that define block sections of code to be used as substitutions.
    public var sections: [String: String]?

    /// An object containing key/value pairs of header names and the value to substitute for them. You must ensure these are properly encoded if they contain unicode characters. Must not be one of the reserved headers.
    public var headers: [String: String]?

    /// An array of category names for this message. Each category name may not exceed 255 characters.
    public var categories: [String]?

    /// Values that are specific to the entire send that will be carried along with the email and its activity data.
    public var customArgs: [String: String]?
    
    /// A unix timestamp allowing you to specify when you want your email to be delivered. This may be overridden by the personalizations[x].send_at parameter. You can't schedule more than 72 hours in advance.
    public var sendAt: Date?

    /// This ID represents a batch of emails to be sent at the same time. Including a batch_id in your request allows you include this email in that batch, and also enables you to cancel or pause the delivery of that batch.
    public var batchId: String?

    /// An object allowing you to specify how to handle unsubscribes.
    public var asm: AdvancedSuppressionManager?

    /// The IP Pool that you would like to send this email from.
    public var ipPoolName: String?

    /// A collection of different mail settings that you can use to specify how you would like this email to be handled.
    public var mailSettings: MailSettings?

    /// Settings to determine how you would like to track the metrics of how your recipients interact with your email.
    public var trackingSettings: TrackingSettings?
    
    public init(personalizations: [Personalization]? = nil,
                from: EmailAddress? = nil,
                replyTo: EmailAddress? = nil,
                subject: String? = nil,
                content: [[String: String]]? = nil,
                attachments: [EmailAttachment]? = nil,
                templateId: String? = nil,
                sections: [String: String]? = nil,
                headers: [String: String]? = nil,
                categories: [String]? = nil,
                customArgs: [String: String]? = nil,
                sendAt: Date? = nil,
                batchId: String? = nil,
                asm: AdvancedSuppressionManager? = nil,
                ipPoolName: String? = nil,
                mailSettings: MailSettings? = nil,
                trackingSettings: TrackingSettings? = nil) {
        self.personalizations = personalizations
        self.from = from
        self.replyTo = replyTo
        self.subject = subject
        self.content = content
        self.attachments = attachments
        self.templateId = templateId
        self.sections = sections
        self.headers = headers
        self.categories = categories
        self.customArgs = customArgs
        self.sendAt = sendAt
        self.batchId = batchId
        self.asm = asm
        self.ipPoolName = ipPoolName
        self.mailSettings = mailSettings
        self.trackingSettings = trackingSettings
    }
    
    public enum CodingKeys: String, CodingKey {
        case personalizations
        case from
        case replyTo = "reply_to"
        case subject
        case content
        case attachments
        case templateId = "template_id"
        case sections
        case headers
        case categories
        case customArgs = "custom_args"
        case sendAt = "send_at"
        case batchId = "batch_id"
        case asm
        case ipPoolName = "ip_pool_name"
        case mailSettings = "mail_settings"
        case trackingSettings = "tracking_settings"
    }
}
