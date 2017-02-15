import SMTP

extension SendGridEmail {

    /*
        Convert a basic Vapor SMTP.Email into a SendGridEmail
    */
    public convenience init(from: Email) {
        self.init(from: from.from, subject: from.subject, body: from.body)
        attachments = from.attachments
        personalizations = [Personalization(to: from.to)]
    }

}
