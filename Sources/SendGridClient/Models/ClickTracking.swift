public enum ClickTracking {
    /*
        Do not track clicks
    */
    case disabled
    /*
        Track clicks in HTML emails only
    */
    case htmlOnly
    /*
        Track clicks in HTML and plain text emails
    */
    case enabled
}
