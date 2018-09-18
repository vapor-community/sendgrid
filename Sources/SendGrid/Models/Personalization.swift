import Vapor

public struct Personalization: Content {

    /// An array of recipients. Each object within this array may contain the name, but must always contain the email, of a recipient.
    public var to: [EmailAddress]?

    /// An array of recipients who will receive a copy of your email. Each object within this array may contain the name, but must always contain the email, of a recipient.
    public var cc: [EmailAddress]?

    /// An array of recipients who will receive a blind carbon copy of your email. Each object within this array may contain the name, but must always contain the email, of a recipient.
    public var bcc: [EmailAddress]?

    /// The subject of your email.
    public var subject: String?

    /// A collection of JSON key/value pairs allowing you to specify specific handling instructions for your email.
    public var headers: [String: String]?

    /// A collection of key/value pairs following the pattern "substitution_tag":"value to substitute".
    public var substitutions: [String: String]?
    
    /// A collection of key/value pairs following the pattern "key":"value" to substitute handlebar template data
    public var dynamicTemplateData: [String: String]?
    
    /// Values that are specific to this personalization that will be carried along with the email and its activity data.
    public var customArgs: [String: String]?
    
    /// A unix timestamp allowing you to specify when you want your email to be delivered. Scheduling more than 72 hours in advance is forbidden.
    public var sendAt: Date?
    
    public init(to: [EmailAddress]? = nil,
                cc: [EmailAddress]? = nil,
                bcc: [EmailAddress]? = nil,
                subject: String? = nil,
                headers: [String: String]? = nil,
                substitutions: [String: String]? = nil,
                dynamicTemplateData: [String: String]? = nil,
                customArgs: [String: String]? = nil,
                sendAt: Date? = nil) {
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.subject = subject
        self.headers = headers
        self.substitutions = substitutions
        self.dynamicTemplateData = dynamicTemplateData
        self.customArgs = customArgs
        self.sendAt = sendAt
    }
    
    public enum CodingKeys: String, CodingKey {
        case to
        case cc
        case bcc
        case subject
        case headers
        case substitutions
        case customArgs = "custom_args"
        case dynamicTemplateData = "dynamic_template_data"
        case sendAt = "send_at"
    }
}
