import Vapor

extension SendGridEmail: NodeRepresentable {

    public func makeNode(context: Context) throws -> Node {
        var obj = Node([:])
        return obj
    }

}
