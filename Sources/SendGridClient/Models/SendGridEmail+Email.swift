import Mail

extension SendGridEmail {

    /*
        Convert a basic Vapor Mail.Email into a SendGridEmail
    */
    public convenience init(from: Mail.Email) {
        try init()
    }

}
