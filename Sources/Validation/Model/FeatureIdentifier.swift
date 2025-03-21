import Foundation

public struct FeatureIdentifier: Hashable, Sendable, Codable, RawRepresentable {
    public var rawValue: UUID
    
    public init(rawValue: UUID) {
        self.rawValue = rawValue
    }
}

public extension FeatureIdentifier {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

    init(from decoder: any Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(UUID.self)
        self.init(rawValue: rawValue)
    }
}
