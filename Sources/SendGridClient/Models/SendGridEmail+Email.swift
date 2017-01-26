import Mail

extension SendGridEmail {

    /*
        Convert a basic Vapor Mail.Email into a SendGridEmail
    */
    public convenience init(from: Mail.Email) {
        self.init(from: from.from, subject: from.subject, body: from.body)
        attachments = from.attachments
        personalizations = [Personalization(to: from.to)]
    }

}
