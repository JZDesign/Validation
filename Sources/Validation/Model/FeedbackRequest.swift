import Foundation

struct FeedbackRequest: Codable, Sendable {
    let featureID: FeatureIdentifier
    let feedback: PosNeg
    let installID: UUID
}

enum PosNeg: String, Codable, Sendable {
    case positive, negative
}
