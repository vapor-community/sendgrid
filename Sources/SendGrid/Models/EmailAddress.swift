//
//  EmailAddress.swift
//  Sendgrid
//
//  Created by Andrew Edwards on 3/29/18.
//

import Vapor

public struct EmailAddress: Content {
    /// format: email
    public var email: String?
    
    /// The name of the person to whom you are sending an email.
    public var name: String?
    
    public init(email: String? = nil,
                name: String? = nil) {
        self.email = email
        self.name = name
    }
}
