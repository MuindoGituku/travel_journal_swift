//
//  MainAppSettingsScreen.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-23.
//

import SwiftUI

struct MainAppSettingsScreen: View {
    
    @State private var showHeroSectionSettingsScreen = false
    @State private var showEntriesListSettingsScreen = false
    
    @State private var showMapSettingsScreen = false
    @State private var showHighlightsSettingsScreen = false
    
    @State private var showAboutTheAppScreen = false
    @State private var showInviteUsersScreen = false
    @State private var showLegalDocsScreen = false
    
    var body: some View {
        List {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 170)
                .cornerRadius(10)
                .foregroundStyle(.blue.opacity(0.3))
                .listRowSeparator(.hidden)
            Section ("Home Screen") {
                SettingsItemCard(
                    iconBackgroundColor: .blue,
                    iconResource: "house.fill",
                    itemTitle: "Hero Section",
                    itemSubtitle: "Manage the hero section display card."
                )
                .onTapGesture {
                    showHeroSectionSettingsScreen = true
                }
                SettingsItemCard(
                    iconBackgroundColor: .green,
                    iconResource: "books.vertical.fill",
                    itemTitle: "Entries List",
                    itemSubtitle: "Manage how the list of entries should appear on the main screen."
                )
                .onTapGesture {
                    showEntriesListSettingsScreen = true
                }
            }
            .listRowSeparator(.hidden)
            
            Section ("Entry Details Screen") {
                SettingsItemCard(
                    iconBackgroundColor: .yellow,
                    iconResource: "map.fill",
                    itemTitle: "Map Details",
                    itemSubtitle: "Manage the map content to be displayed."
                )
                .onTapGesture {
                    showMapSettingsScreen = true
                }
                SettingsItemCard(
                    iconBackgroundColor: .purple,
                    iconResource: "books.vertical.fill",
                    itemTitle: "Highlights Details",
                    itemSubtitle: "Manage how the list of highlights sis displayed."
                )
                .onTapGesture {
                    showHighlightsSettingsScreen = true
                }
            }
            .listRowSeparator(.hidden)
            
            Section ("Legal Documents") {
                SettingsItemCard(
                    iconBackgroundColor: .orange,
                    iconResource: "questionmark",
                    itemTitle: "About the App"
                )
                .onTapGesture {
                    showAboutTheAppScreen = true
                }
                SettingsItemCard(
                    iconBackgroundColor: .cyan,
                    iconResource: "square.and.arrow.up.fill",
                    itemTitle: "Share with Friends",
                    itemSubtitle: "Invite friends to download the app and enjoy."
                )
                .onTapGesture {
                    showInviteUsersScreen = true
                }
                SettingsItemCard(
                    iconBackgroundColor: .brown,
                    iconResource: "signature",
                    itemTitle: "Legal Documents"
                )
                .onTapGesture {
                    showLegalDocsScreen = true
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.grouped)
        .navigationDestination(isPresented: $showHeroSectionSettingsScreen) {
            HeroSectionSettings()
        }
        .navigationDestination(isPresented: $showEntriesListSettingsScreen) {
            
        }
        .navigationDestination(isPresented: $showMapSettingsScreen) {
            
        }
        .navigationDestination(isPresented: $showHighlightsSettingsScreen) {
            
        }
        .navigationDestination(isPresented: $showAboutTheAppScreen) {
            
        }
        .navigationDestination(isPresented: $showInviteUsersScreen) {
            
        }
        .navigationDestination(isPresented: $showLegalDocsScreen) {
            
        }
    }
}

#Preview {
    NavigationStack {
        MainAppSettingsScreen()
    }
}
