public enum SpamCheck {
    /*
        Do not run a spam check.
    */
    case disabled
    /*
        Run a spam check.

        threshold: Strictness of checking, from 1 (least) to 10 (most).
        url: Inbound Parse URL where the email and spam report are sent.
    */
    case enabled(threshold: Int, url: String)
}
