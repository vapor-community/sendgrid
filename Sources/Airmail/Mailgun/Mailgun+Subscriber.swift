import FormData
import Multipart
import Vapor

extension Mailgun {

    public func addSubscriber(_ email: String, toList list: String) throws {
        let uri = try URI("https://api.mailgun.net/v3/lists/\(list)/members")
        let req = Request(method: .post, uri: uri)

        let basic = "api:\(apiKey)".makeBytes().base64Encoded.makeString()
        req.headers["Authorization"] = "Basic \(basic)"

        let subscribed = FormData.Field(
            name: "subscribed",
            filename: nil,
            part: Part(
                headers: [:],
                body: "true".makeBytes()
            )
        )

        let address = FormData.Field(
            name: "address",
            filename: nil,
            part: Part(
                headers: [:],
                body: email.makeBytes()
            )
        )

        req.formData = [
            "subscribed": subscribed,
            "address": address
        ]

        let client = try clientFactory.makeClient(
            hostname: apiURI.hostname,
            port: apiURI.port ?? 443,
            securityLayer: .tls(EngineClient.defaultTLSContext())
        )
        let res = try client.respond(to: req)
        guard res.status.statusCode < 400 else {
            throw Abort.badRequest
        }
    }

}
