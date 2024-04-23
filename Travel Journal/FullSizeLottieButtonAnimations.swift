//
//  FullSizeLottieButtonAnimations.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-18.
//

import SwiftUI
import Lottie

struct FullSizeLottieButtonAnimations: View {
    var animationText = ""
    var animation = LottieAnimations.emptyList
    var animHeightScale = 0.5
    var buttonAction: () -> Void
    var buttonText: String = "Try Again"
    var buttonImage: String = "arrow.clockwise"
    var clickableButton = true
    
    
    var body: some View {
        VStack (alignment:.center) {
            Spacer()
            LottieView(animation: animation)
                .looping()
                .resizable()
                .scaledToFit()
                .frame(maxHeight: UIScreen.main.bounds.height*animHeightScale)
                .padding(.bottom)
            Text(animationText)
                .font(.system(size: 13, weight: .light))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .lineSpacing(5)
                .minimumScaleFactor(0.5)
                .foregroundStyle(.black)
            Spacer()
            Button(action: buttonAction, label: {
                HStack {
                    Image(systemName: buttonImage)
                        .padding(.trailing, 10)
                    Text(buttonText)
                }
                .padding()
            })
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .foregroundStyle(.white)
            .background(.blue)
            .cornerRadius(10)
            .allowsHitTesting(clickableButton)
            Spacer()
        }.padding()
    }
}
