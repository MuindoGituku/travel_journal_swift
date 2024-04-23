//
//  Travel_JournalApp.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-18.
//

import SwiftUI
import FirebaseCore

@main
struct Travel_JournalApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootAppNavigation()
        }
    }
}
