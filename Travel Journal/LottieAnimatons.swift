//
//  LottieAnimatons.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-18.
//

import Lottie

class LottieAnimations {
    static let loading = { LottieAnimation.asset("loading", bundle: .main)! }()
    static let docError = { LottieAnimation.asset("doc_error", bundle: .main)! }()
    static let generalError = { LottieAnimation.asset("general_error", bundle: .main)! }()
    static let emptyList = { LottieAnimation.asset("empty_list", bundle: .main)! }()
    static let success = { LottieAnimation.asset("success", bundle: .main)! }()
    static let add = { LottieAnimation.asset("add", bundle: .main)! }()
}
