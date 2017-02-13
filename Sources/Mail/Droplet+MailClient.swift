import Vapor

private var _mailer: MailClientProtocol.Type?

extension Droplet {
    public var mailer: MailClientProtocol.Type? {
        get {
            return _mailer
        }
        set {
            _mailer = newValue
        }
    }
}
