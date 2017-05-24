//
//  MailgunEmail.swift
//  Mailgun
//
//  Created by Anthony Castelli on 11/14/16.
//
//

import Foundation
import SMTP
import Node

public final class MailgunEmail {
    
    public var from: EmailAddressRepresentable
    public var to: [EmailAddress]
    public var subject: String?
    public var body: EmailBody
    
    public init(to: [EmailAddress], from: EmailAddressRepresentable, subject: String?, body: EmailBody) {
        self.to = to
        self.from = from
        self.subject = subject
        self.body = body
    }
    
    internal func dictionaryRepresentation() -> [String : String] {
        var data = [String : String]()
        data["from"] = self.from.emailAddress.address
        data["to"] = (self.to.map { $0.emailAddress.address }).joined(separator: ",")
        data["subject"] = self.subject
        switch self.body.type {
        case .plain: data["text"] = self.body.content
        case .html: data["html"] = self.body.content
        }
        return data
    }
    
}

extension MailgunEmail {
    
    /*
     Convert a basic Vapor SMTP.Email into a MailgunEmail
     */
    public convenience init(from: Email) {
        self.init(to: from.to, from: from.from, subject: from.subject, body: from.body)
    }
    
}

extension MailgunEmail: NodeRepresentable {
    
    public func makeNode(context: Context) throws -> Node {
        var obj = Node([:])
        // From
        obj["from"] = self.from.emailAddress.address.makeNode()
        
        // To
        obj["to"] = (self.to.map { $0.emailAddress.address }).joined(separator: ",").makeNode()
        
        // Subject
        if let subject = subject {
            obj["subject"] = Node(subject)
        }
        
        // Body
        switch self.body.type {
        case .plain: obj["text"] = self.body.content.makeNode()
        case .html: obj["html"] = self.body.content.makeNode()
        }
        return obj
    }
    
}
