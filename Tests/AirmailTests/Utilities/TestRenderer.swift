import Vapor

final class TestRenderer: ViewRenderer {

    enum Error: Swift.Error {
        case noContextValue
    }

    var shouldCache = false

    func make(_ path: String, _ context: Node) throws -> View {
        guard let value: String = try context.get("value") else {
          throw Error.noContextValue
        }
        return View(data: "\(value)".makeBytes())
    }

}
