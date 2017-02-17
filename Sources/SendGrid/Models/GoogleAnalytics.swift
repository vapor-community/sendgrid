public struct GoogleAnalytics {
    let source: String?
    let medium: String?
    let term: String?
    let content: String?
    let campaign: String?

    public init(source: String?, medium: String, term: String, content: String?, campaign: String?) {
        self.source = source
        self.medium = medium
        self.term = term
        self.content = content
        self.campaign = campaign
    }
}
