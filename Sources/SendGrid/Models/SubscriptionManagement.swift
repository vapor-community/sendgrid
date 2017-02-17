public enum SubscriptionManagement {
    /*
        Do not insert a subscription management link.
    */
    case disabled
    /*
        Append the given content to the email, replacing `<% %>` with the
        subscription management link.

        text: The content to use for plain text emails

        html: The content to use for html emails.
    */
    case appending(text: String?, html: String?)
    /*
        Replace the given tag with the subscription management URL.

        replacingTag: The tag to replace
    */
    case enabled(replacingTag: String)
}
