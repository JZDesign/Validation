import SwiftUI

public struct NewFeature: Identifiable, Codable, Sendable {
    public let id: FeatureIdentifier
    public let title: String
    public let status: Status
    public let createdAt: String
    public let images: [String]
    public let listRowAccentColor: String?

    private let content: String
    
    public var viewContent: LocalizedStringKey {
        LocalizedStringKey(content)
    }
    
    public init(
        id: UUID,
        title: String,
        status: Status,
        createdAt: String,
        content: String,
        images: [String] = [],
        listRowAccentColor: String? = nil
    ) {
        self.id = FeatureIdentifier(rawValue: id)
        self.title = title
        self.status = status
        self.createdAt = createdAt
        self.content = content
        self.images = images
        self.listRowAccentColor = listRowAccentColor
    }
    
    public enum Status: String, Codable, Sendable {
        case ideation, inProgress, complete, canceled
        
        public var display: String {
            switch self {
            case .ideation:
                Strings.FeatureStatus.ideation()
            case .inProgress:
                Strings.FeatureStatus.inProgress()
            case .complete:
                Strings.FeatureStatus.complete()
            case .canceled:
                Strings.FeatureStatus.canceled()
            }
        }
    }
}
