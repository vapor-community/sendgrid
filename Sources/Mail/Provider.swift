import Vapor

public final class Provider<T: MailClientProtocol>: Vapor.Provider {

    public convenience init(config: Config) throws {
        try T.configure(config)
        try self.init()
    }

    public init() throws {}

    public func boot(_ drop: Droplet) {
        if let existing = drop.mailer {
            print("\(String(describing: T.self)) will overwrite existing mailer: \(String(describing: existing))")
        }
        drop.mailer = T.self
    }

    public func afterInit(_ drop: Droplet) {

    }

    public func beforeRun(_ drop: Droplet) {

    }

}
