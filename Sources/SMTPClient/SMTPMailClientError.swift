/*
    An error, either in configuration or in execution.
*/
public enum SMTPMailClientError: Swift.Error {

    /*
        No configuration for SMTP could be found at all.
    */
    case noSMTPConfig
    /*
        A required configuration key was missing. The associated value is the
        name of the missing key.
    */
    case missingConfig(String)

}
