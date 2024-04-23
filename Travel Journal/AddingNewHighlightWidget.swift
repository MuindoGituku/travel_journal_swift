//
//  AddingNewHighlightWidget.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-22.
//

import SwiftUI
import Lottie

struct AddingNewHighlightWidget: View {
    let isFirstEntryToAdd: Bool
    let buttonAction: () -> Void
    
    var body: some View {
        VStack (alignment: .center) {
            LottieView(animation: LottieAnimations.add)
                .looping()
                .resizable()
                .scaledToFit()
                .frame(maxHeight: UIScreen.main.bounds.height*0.3)
                .padding(.bottom)
            Text("Click on the button below to upload a new highlight under your Journal entry for Paris, Italy.")
                .padding([.horizontal, .bottom])
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .medium, design: .rounded))
            Button(
                action: buttonAction,
                label: {
                    HStack {
                        Image(systemName: "plus")
                            .padding(.trailing, 10)
                        Text("Upload New Highlight")
                    }
                    .padding()
                }
            )
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(.blue)
            .cornerRadius(10)
            .padding([.horizontal, .top])
        }
    }
}

#Preview {
    AddingNewHighlightWidget(isFirstEntryToAdd: false, buttonAction: {})
}
