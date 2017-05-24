import SMTP
import Vapor

extension EmailBody {

    public init(_ drop: Droplet, type: EmailBody.BodyType, view path: String) throws {
        try self.init(drop, type: type, view: path, Node.null)
    }

    public init(_ drop: Droplet, type: EmailBody.BodyType, view path: String, _ context: Node) throws {
        let view = try drop.view.make(path, context)
        self.init(type: type, content: view.data.makeString())
    }

}
