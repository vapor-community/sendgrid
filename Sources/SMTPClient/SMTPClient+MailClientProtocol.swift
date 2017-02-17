import HTTP
import Mail
import SMTP
import Vapor
import Foundation
import Transport

var _credentials: SMTPCredentials?
var _host: String?
var _port: Int?
var _securityLayer: SecurityLayer?

extension SMTPClient {

    public static func setSecurityLayer(_ securityLayer: SecurityLayer) {
        _securityLayer = securityLayer
    }

}

extension SMTPClient: MailClientProtocol {

  public static func configure(_ config: Settings.Config) throws {
      guard let c = config["smtp"]?.object else {
          throw SMTPMailClientError.noSMTPConfig
      }
      guard let username = c["username"]?.string else {
          throw SMTPMailClientError.missingConfig("username")
      }
      guard let password = c["password"]?.string else {
          throw SMTPMailClientError.missingConfig("password")
      }
      guard let host = c["host"]?.string else {
          throw SMTPMailClientError.missingConfig("host")
      }
      guard let port = c["port"]?.int else {
          throw SMTPMailClientError.missingConfig("port")
      }
      _credentials = SMTPCredentials(user: username, pass: password)
      _host = host
      _port = port
  }

  public static func boot(_ drop: Vapor.Droplet) {}

  public convenience init() throws {
      guard let host = _host else {
          throw SMTPMailClientError.missingConfig("host")
      }
      guard let port = _port else {
          throw SMTPMailClientError.missingConfig("port")
      }
      guard let securityLayer = _securityLayer else {
          throw SMTPMailClientError.missingConfig("securityLayer")
      }
      try self.init(host: host, port: port, securityLayer: securityLayer)
  }

  public func send(_ emails: [SMTP.Email]) throws {
      guard let credentials = _credentials else {
          throw SMTPMailClientError.missingConfig("username/password")
      }
      try emails.forEach {
          try send($0, using: credentials)
      }
  }

}
