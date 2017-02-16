import Foundation
import SMTP
import Vapor

public struct Personalization {

    /*
        The email recipients
    */
    public let to: [EmailAddress]
    /*
        The email copy recipients
    */
    public let cc: [EmailAddress] = []
    /*
        The email blind copy recipients
    */
    public let bcc: [EmailAddress] = []
    /*
        The email subject, overriding that of the Email, if set
    */
    public let subject: String? = nil
    /*
        Custom headers
    */
    public let headers: [String: String] = [:]
    /*
        Custom substitutions in the format ["tag": "value"]
    */
    public let substitutions: [String: String] = [:]
    /*
        Date to send the email, or `nil` if email to be sent immediately
    */
    public let sendAt: Date? = nil

    public init(to: [EmailAddress]) {
        self.to = to
    }

}

extension Personalization: NodeRepresentable {

    public func makeNode(context: Context) throws -> Node {
        var node = Node([:])
        node["to"] = try Node(to.map { try $0.makeNode() })
        if !cc.isEmpty {
            node["cc"] = try Node(cc.map { try $0.makeNode() })
        }
        if !bcc.isEmpty {
            node["bcc"] = try Node(bcc.map { try $0.makeNode() })
        }
        if let subject = subject {
            node["subject"] = Node(subject)
        }
        if !headers.isEmpty {
            node["headers"] = try headers.makeNode()
        }
        if !substitutions.isEmpty {
            node["substitutions"] = try substitutions.makeNode()
        }
        if let sendAt = sendAt {
            node["send_at"] = Node(sendAt.timeIntervalSince1970)
        }
        return node
    }

}
