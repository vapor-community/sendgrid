import SMTP
import Vapor

extension EmailAddress: NodeRepresentable {

    public func makeNode(context: Context) throws -> Node {
        guard let name = name else {
            return Node(["email": Node(address)])
        }
        return Node(["name": Node(name), "email": Node(address)])
    }

}
