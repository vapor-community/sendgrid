import Vapor

private var _mailer: MailClientProtocol.Type?

extension Droplet {
    /*
        Enables use of the `drop.mailer?.make()` and `drop.mailer?.send(_:)`
        convenience methods.
    */
    public var mailer: MailClientProtocol.Type? {
        get {
            return _mailer
        }
        set {
            _mailer = newValue
        }
    }
}
