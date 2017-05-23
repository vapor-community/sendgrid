import Vapor

private var _mailer: MailClientProtocol.Type?

extension Droplet {
    /*
        Enables use of the `drop.mailer?.make()` and `drop.mailer?.send(_:)`
        convenience methods.

        To match the Vapor 2 paradigm fully, this should be set on the Config
        object and then made immutable here, but we are restricted from that
        approach.
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
