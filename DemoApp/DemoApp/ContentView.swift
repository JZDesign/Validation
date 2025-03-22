//
//  ContentView.swift
//  DemoApp
//
//  Created by Jacob Rakidzich on 3/20/25.
//

import SwiftUI
import Validation

struct ContentView: View {
    let url = URL(string: "https://raw.githubusercontent.com/JZDesign/Validation/refs/heads/main/Tests/ValidationTests/JSON/Sample.JSON")!
    
    var body: some View {
        NavigationView {
            Validation.FeatureFeedbackFlow.FetchingDataFromURL(
                url: url,
                feedbackHandler: ExampleFeedbackHandler(),
                emailAddress: "TheNerd@JacobZivanDesign.com"
            )
        }
    }
}

struct ExampleFeedbackHandler: FeedbackHandling {
    func handleFeedback(_ feedback: Feedback) {
        print("Got it!")
        
        switch feedback {
        case .positive(let featureID):
            print("YAY! \(featureID)")
        case .negative(let featureID):
            print("NAY! \(featureID)")
        }
    }
}

#Preview {
    ContentView()
}
