//
//  FullSizeLottieAnimations.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-18.
//

import SwiftUI
import Lottie

struct FullSizeLottieAnimations: View {
    var animationText = ""
    var animation = LottieAnimations.emptyList
    var animHeightScale = 0.5
    
    var body: some View {
        VStack (alignment:.center) {
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
        }.padding()
    }
}

struct FullWidthLottieAnimations: View {
    var animationText = ""
    var animation = LottieAnimations.emptyList
    var animWidthScale = 0.3
    
    var body: some View {
        HStack (alignment:.center) {
            LottieView(animation: animation)
                .looping()
                .resizable()
                .scaledToFit()
                .frame(maxWidth: UIScreen.main.bounds.width*animWidthScale)
            Spacer()
            Text(animationText)
                .font(.system(size: 13, weight: .light))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .lineSpacing(5)
                .minimumScaleFactor(0.5)
                .foregroundStyle(.black)
        }.padding()
    }
}
