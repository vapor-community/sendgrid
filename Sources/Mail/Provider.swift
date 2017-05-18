import Vapor

public final class Provider<T: MailClientProtocol>: Vapor.Provider {

    // TODO: replace with a `static let` when Swift supports them in generic types
    public static var repositoryName: String {
        return "mail"
    }

    public init(config: Configs.Config) throws {
        try T.configure(config)
    }

    public func boot(_ config: Vapor.Config) throws {}

    public func boot(_ drop: Droplet) throws {
        try T.boot(drop)
        if let existing = drop.mailer {
            print("\(String(describing: T.self)) will overwrite existing mailer: \(String(describing: existing))")
        }
        drop.mailer = T.self
    }

    public func beforeRun(_ drop: Droplet) throws {}

}
