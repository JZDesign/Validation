import SwiftUI

struct NewFeaturesList<RowBackground: ShapeStyle>: View {
    let features: [NewFeature]
    @Binding var loading: Bool
    let positiveColor: Color
    let negativeColor: Color
    let rowBackground: RowBackground
    let feedbackHandler: (Feedback) -> Void
    
    func sampleFeature() -> NewFeature {
        NewFeature(id: .init(), title: "Some Feature", status: .inProgress, createdAt: "Some time", content: "")
    }
    
    var body: some View {
        VStack {
            if features.isEmpty {
                if loading {
                    Group {
                        NewFeatureRow(feature: sampleFeature(), color: .accentColor, background: rowBackground)
                        NewFeatureRow(feature: sampleFeature(), color: .accentColor, background: rowBackground)
                        NewFeatureRow(feature: sampleFeature(), color: .accentColor, background: rowBackground)
                        NewFeatureRow(feature: sampleFeature(), color: .accentColor, background: rowBackground)
                    }.redacted(reason: .placeholder)
                } else {
                    Text(Strings.FeatureList.errorRetrieving())
                        .padding()
                }
            } else {
                ForEach(features) { feature in
                    NavigationLink {
                        FeatureDetailView(
                            feature: feature,
                            positiveColor: positiveColor,
                            negativeColor: negativeColor,
                            feedbackHandler: feedbackHandler
                        )
                        .navigationTitle(feature.title)
                        .background(Material.ultraThin)
                        
                    } label: {
                        NewFeatureRow(
                            feature: feature,
                            color: .accentFromHexCode(feature.listRowAccentColor),
                            background: rowBackground
                        )
                    }
                }
            }
        }
    }
}

struct NewFeatureRow<T: ShapeStyle>: View {
    let feature: NewFeature
    let color: Color
    var background: T

    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 16)
                .mask(
                    Circle()
                        .stroke(style: .init(lineWidth: 6))
                )
            VStack(alignment: .leading) {
                Text(feature.title)
                    .font(.headline.bold())
                Text(feature.createdAt)
                    .font(.callout)
            }
            .padding(.leading)
            .multilineTextAlignment(.leading)
            Spacer()
            Text(feature.status.display)
                .foregroundColor(.white)
                .font(.caption.bold())
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 12).fill(color)
                )
        }
        .padding()
        .background(background)
        .compositingGroup()
        .cornerRadius(16)
        .padding(8)
        .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)
        .contentShape(Rectangle())
        .foregroundColor(.primary)
    }
}
