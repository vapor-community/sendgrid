import Vapor

extension SendGridEmail: NodeRepresentable {

    public func makeNode(in context: Context?) throws -> Node {
        var obj = Node([:])

        // Core settings
        try obj.set("personalizations", personalizations)
        try obj.set("from", from)
        if let replyTo = replyTo {
            try obj.set("reply_to", replyTo)
        }
        if let subject = subject {
            try obj.set("subject", subject)
        }
        if !content.isEmpty {
            try obj.set("content", content.map {
                switch $0.type {
                case .html:
                    return ["type": "text/html", "value": $0.content]
                case .plain:
                    return ["type": "text/plain", "value": $0.content]
                }
            })
        }
        if !attachments.isEmpty {
            try obj.set("attachments", attachments.map {
                [
                    "filename": $0.emailAttachment.filename,
                    "content": $0.emailAttachment.body.base64Encoded.makeString(),
                    "type": $0.emailAttachment.contentType
                ]
            })
        }
        if let templateId = templateId {
            try obj.set("template_id", templateId)
        }
        if !sections.isEmpty {
            try obj.set("sections", sections)
        }
        if !categories.isEmpty {
            try obj.set("categories", categories)
        }
        if let sendAt = sendAt {
            try obj.set("send_at", sendAt.timeIntervalSince1970)
        }
        if let batchId = batchId {
            try obj.set("bach_id", batchId)
        }
        switch unsubscribeHandling {
        case let .usingGroupId(groupId, groups):
            try obj.set("asm", [
                "group_id": groupId,
                "groups_to_display": groups
            ])
        case .default:
            break
        }
        if let ipPoolName = ipPoolName {
            try obj.set("ip_pool_name", ipPoolName)
        }

        // Mail settings
        var ms = Node([:])
        if let bccFirst = bccFirst {
            try ms.set("bcc", [
                "enable": true,
                "email": bccFirst
            ])
        }
        if bypassListManagement {
            try ms.set("bypass_list_management", [
                "enable": true
            ])
        }
        if !footer.isEmpty {
            try ms.set("footer", [
                "enable": true
            ])
            footer.forEach {
                switch $0.type {
                case .html:
                    ms["footer", "html"] = Node($0.content)
                case .plain:
                    ms["footer", "text"] = Node($0.content)
                }
            }
        }
        if sandboxMode {
            try ms.set("sandbox_mode", [
                "enable": true
            ])
        }
        switch spamCheckMode {
        case let .enabled(threshold, url):
            try ms.set("spam_check", [
                "enable": true,
                "threshold": threshold,
                "post_to_url": url
            ])
        case .disabled:
            break
        }
        try obj.set("mail_settings", ms)

        // Tracking settings
        var ts = Node([:])
        switch clickTracking {
        case .enabled:
            try ts.set("click_tracking", [
                "enable": true,
                "enable_text": true
            ])
        case .htmlOnly:
            try ts.set("click_tracking", [
                "enable": true,
                "enable_text": false
            ])
        case .disabled:
            break
        }
        switch openTracking {
        case .enabled(let substitutionTag):
            ts["open_tracking", "enable"] = true
            ts["open_tracking", "substitution_tag"] = substitutionTag?.makeNode(in: context)
        case .disabled:
            break
        }
        switch subscriptionManagement {
        case let .appending(text, html):
            ts["subscription_tracking", "enable"] = true
            ts["subscription_tracking", "text"] = text?.makeNode(in: context)
            ts["subscription_tracking", "html"] = html?.makeNode(in: context)
        case .enabled(let replacingTag):
            ts["subscription_tracking", "enable"] = true
            ts["subscription_tracking", "substitution_tag"] = replacingTag.makeNode(in: context)
        case .disabled:
            break
        }
        if let ga = googleAnalytics {
            ts["ganalytics", "enable"] = true
            ts["ganalytics", "utm_source"] = ga.source?.makeNode(in: context)
            ts["ganalytics", "utm_medium"] = ga.medium?.makeNode(in: context)
            ts["ganalytics", "utm_term"] = ga.term?.makeNode(in: context)
            ts["ganalytics", "utm_content"] = ga.content?.makeNode(in: context)
            ts["ganalytics", "utm_campaign"] = ga.campaign?.makeNode(in: context)
        }
        try obj.set("tracking_settings", ts)

        return obj
    }

}
