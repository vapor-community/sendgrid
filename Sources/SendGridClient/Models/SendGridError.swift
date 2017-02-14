import Vapor

public final class SendgridError: NodeConvertible {
    
    var message: String
    var field: String?
    var help: String?
    
    required public init(node: Node, in context: Context) throws {
        message = try node.extract("message")
        field = try node.extract("field")
        help = try node.extract("help")
    }
    
    public func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "message": message,
            "field": field,
            "help": help
            ])
    }
}
