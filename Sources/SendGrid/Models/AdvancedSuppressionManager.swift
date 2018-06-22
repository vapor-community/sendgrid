import Vapor

public struct AdvancedSuppressionManager: Content {
    /// The unsubscribe group to associate with this email.
    public var groupId: Int?
    
    /// An array containing the unsubscribe groups that you would like to be displayed on the unsubscribe preferences page.
    public var groupsToDisplay: [String]?
    
    public init(groupId: Int? = nil,
                groupsToDisplay: [String]? = nil) {
        self.groupId = groupId
        self.groupsToDisplay = groupsToDisplay
    }
    
    public enum CodingKeys: String, CodingKey {
        case groupId = "group_id"
        case groupsToDisplay = "groups_to_display"
    }
}
