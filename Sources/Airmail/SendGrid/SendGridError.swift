import Node

/*
    An error, either in configuration or in execution.
*/
public enum SendGridError: Error {

    public struct ErrorInfo: NodeInitializable {
        public let message: String
        public let field: String
        public let helpMessage: String

        public init(node: Node) throws {
            message = try node.get("message")
            field = try node.get("field") as String? ?? "NoField"
            helpMessage = try node.get("help") as String? ?? "No help message"
        }
    }

    // SendGrid's errors:
    // https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/errors.html
    case badRequest([ErrorInfo])
    case unauthorized
    case payloadTooLarge
    case tooManyRequests
    case serverError

    // Catch-all error
    case unexpectedServerResponse

}

extension SendGridError: Debuggable {

    public var identifier: String {
        switch self {
        case .badRequest: return "badRequest"
        case .unauthorized: return "unauthorized"
        case .payloadTooLarge: return "payloadTooLarge"
        case .tooManyRequests: return "tooManyRequests"
        case .serverError: return "serverError"
        case .unexpectedServerResponse: return "unexpectedServerResponse"
        }
    }

    public var reason: String {
        switch self {
        case .badRequest:
            return "There was a problem with your request."
        case .unauthorized:
            return "You do not have authorization to make the request."
        case .payloadTooLarge:
            return "The JSON payload you have included in your request is too large."
        case .tooManyRequests:
            return "The number of requests you have made exceeds SendGrid’s rate limitations."
        case .serverError:
            return "An error occurred on a SendGrid server, or the SendGrid v3 Web API is not available."
        case .unexpectedServerResponse:
            return "The SendGrid API returned an undocumented response."
        }
    }

    public var possibleCauses: [String] {
        switch self {
        case .badRequest(let info):
            return info.map { $0.field + ": " + $0.message }
        case .unauthorized:
            return ["Your API key may be expired or set incorrectly."]
        case .payloadTooLarge:
            return ["You may be sending too many emails at once."]
        case .tooManyRequests:
            return ["You are making requests too frequently for your plan."]
        case .serverError:
            return ["An internal SendGrid server error occurred."]
        case .unexpectedServerResponse:
            return ["The V3 API may have undergone a breaking change."]
        }
    }

    public var suggestedFixes: [String] {
        switch self {
        case .badRequest(let info):
            return info.map { $0.field + ": " + $0.helpMessage }
        case .unauthorized:
            return ["Check your API key is current in the SendGrid dashboard."]
        case .payloadTooLarge:
            return ["Send several requests with fewer emails in each."]
        case .tooManyRequests:
            return ["Combine multiple emails into a single request."]
        case .serverError:
            return ["Check the SendGrid dashboard for any further information."]
        case .unexpectedServerResponse:
            return ["Check the SendGrid dashboard for any further information."]
        }
    }

    public var documentationLinks: [String] {
        return ["https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/errors.html"]
    }

}
