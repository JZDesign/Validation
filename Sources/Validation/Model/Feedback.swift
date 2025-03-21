import Foundation

public enum Feedback: Sendable {
    case positive(NewFeature.ID)
    case negative(NewFeature.ID)
}
