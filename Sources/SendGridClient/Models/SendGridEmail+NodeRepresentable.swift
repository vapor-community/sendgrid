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
                    return Node(["type": "text/html", "value": $0.content.makeNode()])
                case .plain:
                    return Node(["type": "text/plain", "value": $0.content.makeNode()])
                }
            })
        }
        // Attachments
        if !attachments.isEmpty {
            obj["attachments"] = try Node(attachments.map {
                Node([
                    "filename": $0.emailAttachment.filename.makeNode(),
                    "content": try $0.emailAttachment.body.makeNode(),
                    "type": $0.emailAttachment.contentType.makeNode(),
                ])
            })
        }
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
        // Mail settings
        obj["mail_settings"] = try {
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
                        ms["footer", "plain"] = Node($0.content)
                    }
                }
            }
            // Sandbox Mode
            if sandboxMode || true {
                ms["sandbox_mode", "enable"] = true
            }
            return ms
        }()

        return obj
    }

}
