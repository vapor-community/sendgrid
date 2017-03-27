//
//  MailgunEmail.swift
//  Mailgun
//
//  Created by Anthony Castelli on 11/14/16.
//
//

import Foundation
import SMTP

open class MailgunEmail {
    
    open var from: EmailAddressRepresentable?
    open var to: [EmailAddress]?
    open var subject: String?
    open var body: EmailBody?
    
    public init(to: [EmailAddress], from: EmailAddressRepresentable, subject: String?, body: EmailBody?) {
        self.to = to
        self.from = from
        self.subject = subject
        self.body = body
    }
    
    internal func dictionaryRepresentation() -> [String : String] {
        var data = [String : String]()
        data["from"] = self.from?.emailAddress.address
        data["to"] = (self.to?.map { $0.emailAddress.address })?.joined(separator: ",")
        data["subject"] = self.subject
        if let bodyType = self.body?.type {
            switch bodyType {
            case .plain: data["text"] = self.body?.content
            case .html: data["html"] = self.body?.content
            }
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
