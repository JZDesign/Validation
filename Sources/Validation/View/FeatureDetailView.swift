import SwiftUI

struct FeatureDetailView: View {
    let feature: NewFeature
    let positiveColor: Color
    let negativeColor: Color
    let feedbackHandler: (Feedback) -> Void
    
    @State var feedbackRecieved = false
    @State var hideBottomSheet = false
    @ScaledMetric var scale = 1
    
    func submitFeedback() {
        withAnimation {
            feedbackRecieved = true
        }
    }
    
    @ViewBuilder
    var gatherFeedback: some View {
        Spacer()
        HStack {
            Text(Strings.GatherFeedbackSection.title())
                .font(.body.bold())
            Spacer()
            Group {
                Button(Strings.GatherFeedbackSection.yes()) {
                    submitFeedback()
                    feedbackHandler(.positive(feature.id))
                }
                .tint(positiveColor)
                Button(Strings.GatherFeedbackSection.no()) {
                    submitFeedback()
                    feedbackHandler(.negative(feature.id))
                }
                .tint(negativeColor)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Text(feature.viewContent)
                        .padding()
                    
                    if !feature.images.isEmpty {
                        Text(Strings.GatherFeedbackSection.exampleImages())
                            .font(.title3)
                            .bold()
                            .padding(.bottom)
                        ForEach(feature.images, id: \.self) { image in
                            AsyncImage(url: URL(string: image)) {
                                $0.resizable()
                            } placeholder: {
                                ProgressView()
                                    .frame(minWidth: 300, minHeight: 300)
                                    .background(Material.regular)
                                    .cornerRadius(8)
                                    .foregroundColor(.accentColor)
                            }
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 300, minHeight: 300)
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                // somewhat mimic readable content width
                .frame(maxWidth: 612 + (12 * scale))
                .frame(maxWidth: .infinity)

                Spacer().frame(height: 300)
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if feedbackRecieved {
                        Text(Strings.GatherFeedbackSection.feedbackReceived())
                            .font(.body.bold())
                            .padding()
                            .onAppear {
                                withAnimation(.linear(duration: 1.25).delay(3)) {
                                    hideBottomSheet = true
                                }
                            }
                    } else {
                        gatherFeedback
                    }
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
                .background(.regularMaterial)
                .compositingGroup()
                .shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: -2)
            }
            .opacity(hideBottomSheet ? 0 : 1)
        }
    }
}

