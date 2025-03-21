import Foundation

public protocol FeedbackHandling {
    func handleFeedback(_ feedback: Feedback)
}

public struct NoOpHandler: FeedbackHandling {
    public func handleFeedback(_ feedback: Feedback) { }
}
