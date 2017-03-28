//
//  MailgunError.swift
//  Mail
//
//  Created by Anthony Castelli on 3/27/17.
//
//

import Foundation
import Node

/*
 An error, either in configuration or in execution.
 */
public enum MailgunError: Swift.Error {
    
    public struct ErrorInfo: NodeInitializable {
        public let message: String
        public let id: String?
        
        public init(node: Node, in context: Context) throws {
            message = try node.extract("message")
            id = try node.extract("id")
        }
    }
    
    /*
     No configuration for Mailgun could be found at all.
     */
    case noMailgunConfig
    
    /*
     A required configuration key was missing. The associated value is the
     name of the missing key.
     */
    case missingConfig(String)
    
    /*
     MailgunClient was instantiated without a Vapor Client. This would
     normally be set via Provider, but if you are instantiating directly,
     you must pass or set the client protocol first.
     */
    case noClient
    
    /*
     There was a problem with your request.
     */
    case badRequest(ErrorInfo?)
    
    /*
     You do not have authorization to make the request.
     */
    case unauthorized
    
    /*
     An error occurred on a SendGrid server, or the SendGrid v3 Web API is
     not available.
     */
    case serverError
    
    /*
     Missing email content
     */
    case missingEmailContent
    
    case unexpectedServerResponse
}
