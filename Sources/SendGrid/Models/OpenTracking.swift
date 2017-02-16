public enum OpenTracking {
    /*
        Do not track opens
    */
    case disabled
    /*
        Track opens in emails.

        substitutionTag: This tag will be replaced by the open tracking pixel.
    */
    case enabled(substitutionTag: String?)
}
