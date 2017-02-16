import Node

/*
    An error, either in configuration or in execution.
*/
public enum SendGridError: Swift.Error {

    public struct ErrorInfo: NodeInitializable {
        public let message: String
        public let field: String?
        public let helpMessage: String?

        public init(node: Node, in context: Context) throws {
            message = try node.extract("message")
            field = try node.extract("field")
            helpMessage = try node.extract("help")
        }
    }

    /*
        No configuration for SendGrid could be found at all.
    */
    case noSendGridConfig
    /*
        A required configuration key was missing. The associated value is the
        name of the missing key.
    */
    case missingConfig(String)
    /*
        SendGridClient was instantiated without a Vapor Client. This would
        normally be set via Provider, but if you are instantiating directly,
        you must pass or set the client protocol first.
    */
    case noClient

    // SendGrid's errors:
    // https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/errors.html
    /*
        There was a problem with your request.
    */
    case badRequest([ErrorInfo])
    /*
        You do not have authorization to make the request.
    */
    case unauthorized
    /*
        The JSON payload you have included in your request is too large.
    */
    case payloadTooLarge
    /*
        The number of requests you have made exceeds SendGrid’s rate
        limitations.
    */
    case tooManyRequests
    /*
        An error occurred on a SendGrid server, or the SendGrid v3 Web API is
        not available.
    */
    case serverError

    case unexpectedServerResponse
}
