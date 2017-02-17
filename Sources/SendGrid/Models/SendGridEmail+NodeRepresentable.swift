import Vapor

extension SendGridEmail: NodeRepresentable {

    public func makeNode(context: Context) throws -> Node {
        var obj = Node([:])
        // Personalizations
        obj["personalizations"] = try personalizations.makeNode()
        // From
        obj["from"] = try from.makeNode()
        // Reply To
        if let replyTo = replyTo {
            obj["reply_to"] = try replyTo.makeNode()
        }
        // Subject
        if let subject = subject {
            obj["subject"] = Node(subject)
        }
        // Content
        if !content.isEmpty {
            obj["content"] = Node(content.map {
                switch $0.type {
                case .html:
                    return Node(["type": "text/html",
                                 "value": $0.content.makeNode()])
                case .plain:
                    return Node(["type": "text/plain",
                                 "value": $0.content.makeNode()])
                }
            })
        }
        // Attachments
        if !attachments.isEmpty {
            obj["attachments"] = Node(attachments.map {
                Node([
                    "filename": $0.emailAttachment.filename.makeNode(),
                    "content": Node($0.emailAttachment.body.base64String),
                    "type": $0.emailAttachment.contentType.makeNode(),
                ])
            })
        }
        print(String(describing: obj["attachments"]))
        // Template Id
        if let templateId = templateId {
            obj["template_id"] = Node(templateId)
        }
        // Sections
        if !sections.isEmpty {
            obj["sections"] = try sections.makeNode()
        }
        // Categories
        if !categories.isEmpty {
            obj["categories"] = try categories.makeNode()
        }
        // Send At
        if let sendAt = sendAt {
            obj["send_at"] = Node(sendAt.timeIntervalSince1970)
        }
        // Batch Id
        if let batchId = batchId {
            obj["batch_id"] = Node(batchId)
        }
        // asm
        switch unsubscribeHandling {
        case let .usingGroupId(groupId, groups):
            obj["asm", "group_id"] = Node(groupId)
            obj["asm", "groups_to_display"] = Node(groups.map { Node($0) })
        case .default:
            break
        }
        // IP Pool Name
        if let ipPoolName = ipPoolName {
            obj["ip_pool_name"] = Node(ipPoolName)
        }
        /// MAIL SETTINGS
        var ms = Node([:])
        // BCC
        if let bccFirst = bccFirst {
            ms["bcc", "enable"] = true
            ms["bcc", "email"] = try bccFirst.makeNode()
        }
        // Bypass List Management
        if bypassListManagement {
            ms["bypass_list_management", "enable"] = true
        }
        // Footer
        if !footer.isEmpty {
            ms["footer", "enable"] = true
            footer.forEach {
                switch $0.type {
                case .html:
                    ms["footer", "html"] = Node($0.content)
                case .plain:
                    ms["footer", "text"] = Node($0.content)
                }
            }
        }
        // Sandbox Mode
        if sandboxMode {
            ms["sandbox_mode", "enable"] = true
        }
        // Spam Check
        switch spamCheckMode {
        case let .enabled(threshold, url):
            ms["spam_check", "enable"] = true
            ms["spam_check", "threshold"] = Node(threshold)
            ms["spam_check", "post_to_url"] = Node(url)
        case .disabled:
            break
        }
        obj["mail_settings"] = ms
        /// TRACKING SETTINGS
        var ts = Node([:])
        // Click Tracking
        switch clickTracking {
        case .enabled:
            ts["click_tracking", "enable"] = true
            ts["click_tracking", "enable_text"] = true
        case .htmlOnly:
            ts["click_tracking", "enable"] = true
            ts["click_tracking", "enable_text"] = false
        case .disabled:
            break
        }
        // Open Tracking
        switch openTracking {
        case .enabled(let substitutionTag):
            ts["open_tracking", "enable"] = true
            ts["open_tracking", "substitution_tag"] = substitutionTag?.makeNode()
        case .disabled:
            break
        }
        // Subscription Tracking
        switch subscriptionManagement {
        case let .appending(text, html):
            ts["subscription_tracking", "enable"] = true
            ts["subscription_tracking", "text"] = text?.makeNode()
            ts["subscription_tracking", "html"] = html?.makeNode()
        case .enabled(let replacingTag):
            ts["subscription_tracking", "enable"] = true
            ts["subscription_tracking", "substitution_tag"] = Node(replacingTag)
        case .disabled:
            break
        }
        // Google Analytics
        if let ga = googleAnalytics {
            ts["ganalytics", "enable"] = true
            ts["ganalytics", "utm_source"] = ga.source?.makeNode()
            ts["ganalytics", "utm_medium"] = ga.medium?.makeNode()
            ts["ganalytics", "utm_term"] = ga.term?.makeNode()
            ts["ganalytics", "utm_content"] = ga.content?.makeNode()
            ts["ganalytics", "utm_campaign"] = ga.campaign?.makeNode()
        }
        obj["tracking_settings"] = ts
        return obj
    }

}
