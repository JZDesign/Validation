import SwiftUI

/// The screen that contains the list of upcoming features
///
/// - Important: Requires a Navigation View
struct ReviewUpcomingFeaturesScreen<RowBackground: ShapeStyle>: View {
    @StateObject var viewModel: NewFeaturesViewModel
    let feedbackHandler: FeedbackHandling
    let emailAddress: String?
    let positiveColor: Color
    let negativeColor: Color
    let rowBackground: RowBackground

    @Environment(\.openURL) var openURL
    @ScaledMetric var scale = 1
    
    /// Create the screen that contains the list of upcoming features
    /// - Parameters:
    ///   - viewModel: The view model that will manage loading state and displaying the new features
    ///   - feedbackHandler: An object that can collect user feedback
    ///   - emailAddress: A support email address if you would like more detailed feedback sent your way
    ///   - positiveColor: The color of the positive feedback button
    ///   - negativeColor: The color of the negative feedback button
    ///
    /// - Important: Requires a Navigation View
    init(
        viewModel: NewFeaturesViewModel,
        feedbackHandler: FeedbackHandling,
        emailAddress: String? = nil,
        positiveColor: Color = .green,
        negativeColor: Color = .red
    ) where RowBackground == Material {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.feedbackHandler = feedbackHandler
        self.emailAddress = emailAddress
        self.positiveColor = positiveColor
        self.negativeColor = negativeColor
        self.rowBackground = .thin
    }
    
    /// Create the screen that contains the list of upcoming features
    /// - Parameters:
    ///   - viewModel: The view model that will manage loading state and displaying the new features
    ///   - feedbackHandler: An object that can collect user feedback
    ///   - emailAddress: A support email address if you would like more detailed feedback sent your way
    ///   - positiveColor: The color of the positive feedback button
    ///   - negativeColor: The color of the negative feedback button
    ///   - rowBackground: A shape style to decorate the list row background
    /// - Important: Requires a Navigation View
    init(
        viewModel: NewFeaturesViewModel,
        feedbackHandler: FeedbackHandling,
        emailAddress: String? = nil,
        positiveColor: Color = .green,
        negativeColor: Color = .red,
        rowBackground: RowBackground
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.feedbackHandler = feedbackHandler
        self.emailAddress = emailAddress
        self.positiveColor = positiveColor
        self.negativeColor = negativeColor
        self.rowBackground = rowBackground
    }

    @ViewBuilder
    var emailRow: some View {
        if let emailAddress, let url = URL(string: "mailto:" + emailAddress) {
            VStack(alignment: .leading) {
                HStack {
                    Text(Strings.GatherFeedbackSection.contactUsTitle())
                    Spacer()
                }
            }
            .padding()
            .font(.title.weight(.black))

            VStack {
                HStack {
                    Text(Strings.GatherFeedbackSection.submitFeedback())
                        .font(.headline.bold())
                    Spacer()
                    Image(systemName: "envelope")
                }
                .padding(.horizontal)
            }
            .accessibilityElement(children: .combine)
            .padding()
            .background(rowBackground)
            .cornerRadius(16)
            .padding(8)
            .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)
            .contentShape(Rectangle())
            .foregroundColor(.primary)
            .onTapGesture {
                openURL(url)
            }
            .accessibilityAction {
                openURL(url)
            }
            .padding(.bottom)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                emailRow
                VStack(alignment: .leading) {
                    HStack {
                        Text(Strings.FeatureList.title())
                            .font(.title.weight(.black))
                        Spacer()
                    }
                }.padding()
                NewFeaturesList(
                    features: viewModel.features,
                    loading: $viewModel.isLoading,
                    positiveColor: positiveColor,
                    negativeColor: negativeColor,
                    rowBackground: rowBackground,
                    feedbackHandler: feedbackHandler.handleFeedback
                )
                .task {
                    if viewModel.features.isEmpty {
                        try? await viewModel.getFeaturesAsync()
                    }
                }
            }
            // somewhat mimic readable content width
            .frame(maxWidth: 612 + (12 * scale))
            .frame(maxWidth: .infinity)
        }
        .background(Material.ultraThin)
        
        // For iPad layouts, auto display the first feature in the master detail style
        if let feature = viewModel.features.first {
            FeatureDetailView(
                feature: feature,
                positiveColor: positiveColor,
                negativeColor: negativeColor,
                feedbackHandler: feedbackHandler.handleFeedback
            )
            .background(Material.ultraThin)
            .navigationTitle(feature.title)
        }
    }
}

#Preview {
    NavigationView {
        ReviewUpcomingFeaturesScreen(
            viewModel: .init(featureRetriever: MockRetriever()),
            feedbackHandler: NoOpHandler(),
            emailAddress: nil,
            positiveColor: .green,
            negativeColor: .red
        )
    }
}

private struct MockRetriever: FeatureRetrieving {
    func getFeatures() async throws -> [NewFeature] {
        [.init(
            id: .init(),
            title: "This is a test",
            status: .inProgress,
            createdAt: "Jan 1",
            content: "*Test*, **Test**, [TEST](https://jacobzivandesign.com) ![Test](https://jacobzivandesign.com/images/memoji.png)",
            images: ["https://jacobzivandesign.com/images/memoji.png"]
        )]
    }
}
