import SwiftUI

/// Assembles the views and dependencies to use the Validation Framework
public enum Validation {
    public enum FeatureFeedbackFlow {
        // MARK: - Just Views - Consumer supplies all logic to populate the view and handle feedback
        
        /// Supply all of your own configuration, and just rely on the views.
        public struct Custom: View {
            let feedbackHandler: FeedbackHandling
            let viewModel: NewFeaturesViewModel
            let emailAddress: String?
            let positiveColor: Color
            let negativeColor: Color
            
            /// Supply all of your own configuration, and use the views from the Validation SDK
            /// - Parameters:
            ///   - feedbackHandler: An implementation of the feedback handling protocol that will be responsible for recording user feedback
            ///   - viewModel: The configured view model that can fetch the ``[NewFeature]`` data and supply it to the view.
            ///   - emailAddress: A support email address to collect longer form feedback
            ///   - positiveColor: The positive feedback button background color
            ///   - negativeColor: The negative feedback button background color
            ///
            /// - Important: Needs to be in a navigation view heirarchy
            public init(
                feedbackHandler: FeedbackHandling,
                viewModel: NewFeaturesViewModel,
                emailAddress: String?,
                positiveColor: Color,
                negativeColor: Color
            ) {
                self.feedbackHandler = feedbackHandler
                self.viewModel = viewModel
                self.emailAddress = emailAddress
                self.positiveColor = positiveColor
                self.negativeColor = negativeColor
            }
            
            public var body: some View {
                ReviewUpcomingFeaturesScreen(
                    viewModel: viewModel,
                    feedbackHandler: feedbackHandler,
                    emailAddress: emailAddress,
                    positiveColor: positiveColor,
                    negativeColor: negativeColor
                )
            }
        }
        
        // MARK: Partially configured views - We supply Fetching, consumer still handles feedback
        
        /// Creates the Validation UI that will automatically fetch the data from the URL that was provided.
        ///
        /// - Important: Needs to be in a navigation view heirarchy
        public struct FetchingDataFromURL: View {
            let feedbackHandler: FeedbackHandling
            let viewModel: NewFeaturesViewModel
            let emailAddress: String?
            let positiveColor: Color
            let negativeColor: Color
            
            @MainActor
            /// Creates the Validation UI that will automatically fetch the data from the URL that was provided.
            /// - Parameters:
            ///   - url: Where the ``[NewFeature]`` data will be provided from
            ///   - feedbackHandler: An implementation of the feedback handling protocol that will be responsible for recording user feedback
            ///   - emailAddress: A support email address to collect longer form feedback
            ///   - positiveColor: The positive feedback button background color
            ///   - negativeColor: The negative feedback button background color
            ///
            /// - Important: Needs to be in a navigation view heirarchy
            public init(
                url: URL,
                feedbackHandler: FeedbackHandling,
                emailAddress: String? = nil,
                positiveColor: Color = .green,
                negativeColor: Color = .red
            ) {
                self.feedbackHandler = feedbackHandler
                self.viewModel = .init(featureRetriever: NewFeatureRepository(url: url, getFeatures: RemoteFeatureRetriever().getFeatures))
                self.emailAddress = emailAddress
                self.positiveColor = positiveColor
                self.negativeColor = negativeColor
            }
            
            public var body: some View {
                ReviewUpcomingFeaturesScreen(
                    viewModel: viewModel,
                    feedbackHandler: feedbackHandler,
                    emailAddress: emailAddress,
                    positiveColor: positiveColor,
                    negativeColor: negativeColor
                )
            }
        }
        
        // MARK: - Fully Configured Views - you just host the endpoints
        // TODO: Make view where the consumer can provide 2 urls. One to get the data and another to handle the feedback.
        
        // MARK: - We do it all for a fee
        // TODO: Make a view that takes only an SDK key and theming configurations
    }
}
