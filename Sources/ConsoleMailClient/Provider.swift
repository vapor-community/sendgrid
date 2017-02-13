import Vapor

public final class Provider: Vapor.Provider {

    public convenience init(config: Config) throws {
        try self.init()
    }

    public init() throws {}

    public func boot(_ drop: Droplet) {
        if let existing = drop.mailer {
            print("ConsoleMailClient will overwrite existing mailer: \(type(of: existing))")
        }
        drop.mailer = MailClient.self
    }

    public func afterInit(_ drop: Droplet) {

    }

    public func beforeRun(_ drop: Droplet) {

    }

}
