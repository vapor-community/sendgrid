import Mail
import SMTP
import Vapor
import Sockets

var _credentials: SMTPCredentials?
var _scheme: String?
var _hostname: String?
var _port: UInt16?

/**
    Wraps Vapor's own SMTPClient to provide limited SMTP support.
*/
public final class SMTPMailClient {

    let smtp: SMTPClient<TCPInternetSocket>

    public init() throws {
        guard let scheme = _scheme else {
            throw ConfigError.missing(key: ["scheme"], file: "smtp", desiredType: String.self)
        }
        guard let hostname = _hostname else {
            throw ConfigError.missing(key: ["hostname"], file: "smtp", desiredType: String.self)
        }
        guard let port = _port else {
            throw ConfigError.missing(key: ["port"], file: "smtp", desiredType: UInt16.self)
        }
        let stream = try TCPInternetSocket(scheme: scheme, hostname: hostname, port: port)
        smtp = try SMTPClient(stream)
    }

}

extension SMTPMailClient: MailClientProtocol {

    public static func configure(_ config: Vapor.Config) throws {
        guard let c = config["smtp"]?.object else {
            throw ConfigError.missingFile("smtp")
        }
        guard let username = c["username"]?.string else {
            throw ConfigError.missing(key: ["username"], file: "smtp", desiredType: String.self)
        }
        guard let password = c["password"]?.string else {
            throw ConfigError.missing(key: ["password"], file: "smtp", desiredType: String.self)
        }
        guard let scheme = c["scheme"]?.string else {
            throw ConfigError.missing(key: ["scheme"], file: "smtp", desiredType: String.self)
        }
        guard let hostname = c["hostname"]?.string else {
            throw ConfigError.missing(key: ["hostname"], file: "smtp", desiredType: String.self)
        }
        guard let port = c["port"]?.uint else {
            throw ConfigError.missing(key: ["port"], file: "smtp", desiredType: UInt16.self)
        }
        _credentials = SMTPCredentials(user: username, pass: password)
        _scheme = scheme
        _hostname = hostname
        _port = UInt16(port)
    }

    public static func boot(_ drop: Vapor.Droplet) {}

    public func send(_ emails: [SMTP.Email]) throws {
        guard let credentials = _credentials else {
            throw ConfigError.missing(key: ["username/password"], file: "smtp", desiredType: String.self)
        }
        try emails.forEach {
            try smtp.send($0, using: credentials)
        }
    }

}
