import Vapor

// final class TestRenderer: ViewRenderer {
//     let viewsDir: String
//     var views: [String: Bytes]
//
//     init(viewsDir: String) {
//         self.viewsDir = viewsDir
//         self.views = [:]
//     }
//
//     enum Error: Swift.Error {
//         case viewNotFound
//     }
//
//     func make(_ path: String, _ context: Node) throws -> Vapor.View {
//       return try make(path, context, for: nil)
//     }
//
//     func make(_ path: String, _ context: Node, for provider: Provider.Type?) throws -> View {
//         guard let bytes = self.views[path] else {
//             throw Error.viewNotFound
//         }
//
//         return View(data: bytes)
//     }
// }

final class TestRenderer: ViewRenderer {

    init(viewsDir: String) {}

    func make(_ path: String, _ context: Node) throws -> Vapor.View {
        return try make(path, context, for: nil)
    }

    func make(_ path: String, _ context: Node, for provider: Provider.Type?) throws -> View {
        return try View(data: "\(context)".makeBytes())

    }

}
