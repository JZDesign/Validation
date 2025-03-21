import Foundation

public enum Strings {
    public enum FeatureStatus: String.LocalizationValue, AutoLocalizing, CaseIterable {
        case ideation = "FEATURE_IN_IDEATION"
        case inProgress = "FEATURE_IN_PROGRESS"
        case complete = "FEATURE_COMPLETE"
        case canceled = "FEATURE_CANCELED"
    }
    
    public enum GatherFeedbackSection: String.LocalizationValue, AutoLocalizing, CaseIterable {
        case title = "GATHER_FEEDBACK_TITLE"
        case yes = "GATHER_FEEDBACK_POSITIVE"
        case no = "GATHER_FEEDBACK_NEGATIVE"
        case feedbackReceived = "FEEDBACK_RECEIVED"
        case exampleImages = "EXAMPLE_IMAGES"
        case contactUsTitle = "CONTACT_US_TITLE"
        case submitFeedback = "SUBMIT_FEEDBACK"
    }
    
    public enum FeatureList: String.LocalizationValue, AutoLocalizing, CaseIterable {
        case errorRetrieving = "ERROR_FINDING_FEATURES"
        case title = "FEATURES_LIST_TITLE"
    }
}
