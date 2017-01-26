/*
    Footer to append to the email. Can be either plaintext or HTML.
*/
public struct Footer {
    public enum ContentType {
        case html, plain
    }

    public let type: ContentType
    public let content: String

    public init(type: ContentType, content: String) {
        self.type = type
        self.content = content
    }
}

extension Footer: Equatable {}
public func ==(lhs: Footer, rhs: Footer) -> Bool {
    return lhs.type == rhs.type
        && lhs.content == rhs.content
}
