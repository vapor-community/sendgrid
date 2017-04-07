import Vapor

final class TestRenderer: ViewRenderer {

    init(viewsDir: String) {}

    func make(_ path: String, _ context: Node) throws -> Vapor.View {
        return try make(path, context, for: nil)
    }

    func make(_ path: String, _ context: Node, for provider: Provider.Type?) throws -> View {
        return try View(data: "\(context)".makeBytes())

    }

}
