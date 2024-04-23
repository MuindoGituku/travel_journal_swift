//
//  RootAppNavigation.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-23.
//

import SwiftUI

struct RootAppNavigation: View {
    @State private var selectedTab: Int = 0
    
    private func navigationTitle(for tag: Int) -> String {
        switch tag {
        case 0:
            return "Travel Journal"
        case 1:
            return "Settings"
        default:
            return "Travel Journal"
        }
    }
    
    var body: some View {
        NavigationStack {
            TabView(
                selection: $selectedTab,
                content:  {
                    AllJournalEntriesList()
                        .tabItem {
                            Label("Journal", systemImage: "books.vertical.fill")
                        }
                        .tag(0)
                    MainAppSettingsScreen()
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                        .tag(1)
                }
            )
            .navigationTitle(navigationTitle(for: selectedTab))
        }
    }
}

#Preview {
    RootAppNavigation()
}
