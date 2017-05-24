//
//  MailgunClient.swift
//  Mailgun
//
//  Created by Anthony Castelli on 11/14/16.
//
//

import Console
import Vapor
import HTTP
import Foundation
import SMTP
import Mail


/**
 Mailgun client
 */
public final class MailgunClient {
    
    static var defaultApiKey: String?
    static var defaultDomain: String?
    static var defaultClient: ClientProtocol.Type?
    
    var domain: String
    var apiKey: String
    var client: ClientProtocol
    
    public init(clientProtocol: ClientProtocol.Type, domain: String, apiKey: String) throws {
        self.domain = domain
        self.apiKey = apiKey
        self.client = try clientProtocol.make(scheme: "https", host: "api.mailgun.net")
    }
    
    public func send(_ emails: [MailgunEmail]) throws {
        try emails.forEach { email in
            let boundary = "vapor.mailgun.package.\(SecureToken().token)"
            let bytes = try createMultipartData(email.makeNode(), boundary: boundary)
            let headers: [HeaderKey : String] = [
                "Authorization": authorizationHeaderValue(apiKey),
                "Content-Type": "multipart/form-data; boundary=\(boundary)"
            ]
            let response = try client.post(path: "/v3/\(domain)/messages", headers: headers, body: Body.data(bytes))
            switch response.status.statusCode {
            case 200, 202: return
            case 400: throw MailgunError.badRequest(try response.json?.extract())
            case 401: throw MailgunError.unauthorized
            case 500, 503: throw MailgunError.serverError
            default: throw MailgunError.unexpectedServerResponse
            }
        }
    }
    
    fileprivate func authorizationHeaderValue(_ apiKey: String) -> String {
        let userPasswordString = "api:\(apiKey)"
        guard let userPasswordData = userPasswordString.data(using: String.Encoding.utf8) else { return "" }
        let base64EncodedCredential = userPasswordData.base64EncodedString()
        let authString = "Basic \(base64EncodedCredential)"
        return authString
    }
    
    fileprivate func createMultipartData(_ node: Node, boundary: String) throws -> Bytes {
        var serialized = ""
        
        guard let object = node.object else { throw MailgunError.missingEmailContent }
        object.forEach { key, value in
            guard let value = value.string else { return }
            serialized += "--\(boundary)\r\n"
            serialized += "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
            serialized += "\(value)\r\n"
        }
        
        serialized += "--\(boundary)--\r\n"
        return serialized.bytes
    }
    
}

// MARK: Mailing lists

extension MailgunClient {
    public func addSubscriber(_ email: String, toList list: String) throws {
        let boundary = "vapor.mailgun.package.\(SecureToken().token)"
        
        let node = Node([
            "subscribed": true.makeNode(),
            "address": email.makeNode()
            ])
        
        let bytes = try createMultipartData(node, boundary: boundary)
        let headers: [HeaderKey : String] = [
            "Authorization": authorizationHeaderValue(apiKey),
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        let response = try client.post(path: "/v3/lists/\(list)/members", headers: headers, body: Body.data(bytes))
        switch response.status.statusCode {
        case 200, 202: return
        case 400: throw MailgunError.badRequest(try response.json?.extract())
        case 401: throw MailgunError.unauthorized
        case 500, 503: throw MailgunError.serverError
        default: throw MailgunError.unexpectedServerResponse
        }
    }
    
    public func send(_ email: MailgunEmail, toList list: String) throws {
        // To send an email to a mailgun mailing list we have to set the
        // To field to the list's email.
        var emailNode = try email.makeNode()
        emailNode["to"] = list.makeNode()
        
        let boundary = "vapor.mailgun.package.\(SecureToken().token)"
        let bytes = try createMultipartData(emailNode, boundary: boundary)
        let headers: [HeaderKey : String] = [
            "Authorization": authorizationHeaderValue(apiKey),
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        let response = try client.post(path: "/v3/\(domain)/messages", headers: headers, body: Body.data(bytes))
        switch response.status.statusCode {
        case 200, 202: return
        case 400: throw MailgunError.badRequest(try response.json?.extract())
        case 401: throw MailgunError.unauthorized
        case 500, 503: throw MailgunError.serverError
        default: throw MailgunError.unexpectedServerResponse
        }
    }
    
    public func send(_ email: SMTP.Email, toList list: String) throws {
        // Convert to Mailgun Emails and then send
        try send(MailgunEmail(from: email), toList: list)
    }
    
}

extension MailgunClient: MailClientProtocol {
    
    public static func configure(_ config: Settings.Config) throws {
        guard let mg = config["mailgun"]?.object else {
            throw MailgunError.noMailgunConfig
        }
        guard let domain = mg["domain"]?.string else {
            throw MailgunError.missingConfig("domain")
        }
        guard let apiKey = mg["apiKey"]?.string else {
            throw MailgunError.missingConfig("apiKey")
        }
        defaultDomain = domain
        defaultApiKey = apiKey
    }
    
    public static func boot(_ drop: Vapor.Droplet) {
        self.defaultClient = drop.client
    }
    
    public convenience init() throws {
        guard let client = MailgunClient.defaultClient else {
            throw MailgunError.noClient
        }
        guard let domain = MailgunClient.defaultDomain else {
            throw MailgunError.missingConfig("domain")
        }
        guard let apiKey = MailgunClient.defaultApiKey else {
            throw MailgunError.missingConfig("apiKey")
        }
        try self.init(clientProtocol: client, domain: domain, apiKey: apiKey)
    }
    
    public func send(_ emails: [SMTP.Email]) throws {
        // Convert to Mailgun Emails and then send
        let mgEmails = emails.map { MailgunEmail(from: $0 ) }
        try send(mgEmails)
    }
    
}
