import SMTP
import Vapor

extension EmailAddress: NodeRepresentable {

    public func makeNode(in context: Context?) throws -> Node {
        guard let name = name else {
            return try ["email": address].makeNode(in: context)
        }
        return try ["name": name, "email": address].makeNode(in: context)
    }

}
