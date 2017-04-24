import XCTest
import Mail
import SMTP
import Mailgun
@testable import Vapor


class MailgunClientTests: XCTestCase {
    static let allTests = [
        ("testProvider", testProvider),
        ("testAddingToList", testAddingToList),
        ("testSendingToList", testSendingToList),
    ]
    
    let apiKey = "MG.YOUR_KEY" // Set here, but don't commit to git!
    let domain = "MG.YOUR_DOMAIN" // Set here, but don't commit to git!
    
    func testProvider() throws {
        if apiKey == "MG.YOUR_KEY" {
            print("Not testing Mailgun as no API Key is set")
            return
        }
        if apiKey == "MG.YOUR_DOMAIN" {
            print("Not testing Mailgun as no domain is set")
            return
        }
        let config = Config([
            "mailgun": [
                "apiKey": Node(apiKey),
                "domain": Node(domain)
            ],
        ])
        let drop = try makeDroplet(config: config)
        try drop.addProvider(Mail.Provider<MailgunClient>.self)
        
        let email = SMTP.Email(from: "vapor-mailgun-from@mailinator.com",
                               to: "vapor-mailgun@mailinator.com",
                               subject: "Email Subject",
                               body: "Hello Email")
        try drop.mailer?.send(email)
    }
    
    func testAddingToList() throws {
        if apiKey == "MG.YOUR_KEY" {
            print("Not testing Mailgun as no API Key is set")
            return
        }
        if apiKey == "MG.YOUR_DOMAIN" {
            print("Not testing Mailgun as no domain is set")
            return
        }
        let config = Config([
            "mailgun": [
                "apiKey": Node(apiKey),
                "domain": Node(domain)
            ],
        ])
        let drop = try makeDroplet(config: config)
        try drop.addProvider(Mail.Provider<MailgunClient>.self)
        
        try MailgunClient().addSubscriber("vapor-mailgun@mailinator.com", toList: "vapor-mailgun-list@mailinator.com")
    }
    
    func testSendingToList() throws {
        if apiKey == "MG.YOUR_KEY" {
            print("Not testing Mailgun as no API Key is set")
            return
        }
        if apiKey == "MG.YOUR_DOMAIN" {
            print("Not testing Mailgun as no domain is set")
            return
        }
        let config = Config([
            "mailgun": [
                "apiKey": Node(apiKey),
                "domain": Node(domain)
            ],
        ])
        let drop = try makeDroplet(config: config)
        try drop.addProvider(Mail.Provider<MailgunClient>.self)
        
        // The To is not used when sending a mailing list email
        let email = SMTP.Email(from: "vapor-mailgun-list@mailinator.com",
                               to: "",
                               subject: "Email Subject",
                               body: "Hello Email")

        try MailgunClient().send(email, toList: "vapor-mailgun-list@mailinator.com")
    }
    
}

extension MailgunClientTests {
    func makeDroplet(config: Config? = nil) throws -> Droplet {
        let drop = Droplet(arguments: ["/dummy/path/", "prepare"], config: config)
        try drop.runCommands()
        return drop
    }
}
