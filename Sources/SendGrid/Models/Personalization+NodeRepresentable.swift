import Vapor

extension Personalization: NodeRepresentable {

    public func makeNode(in context: Context?) throws -> Node {
        var node = Node([:])
        try node.set("to", to)
        if !cc.isEmpty {
            try node.set("cc", cc)
        }
        if !bcc.isEmpty {
            try node.set("bcc", bcc)
        }
        if let subject = subject {
            try node.set("subject", subject)
        }
        if !headers.isEmpty {
            try node.set("headers", headers)
        }
        if !substitutions.isEmpty {
            try node.set("substitutions", substitutions)
        }
        if let sendAt = sendAt {
            try node.set("send_at", sendAt.timeIntervalSince1970)
        }
        return node
    }

}
