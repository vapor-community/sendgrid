import Vapor
public struct SendGridError: Error, Content {
    public var errors: [SendGridErrorResponse]?
}

public struct SendGridErrorResponse: Content {
    public var message: String?
    public var field: String?
    public var help: String?
}
