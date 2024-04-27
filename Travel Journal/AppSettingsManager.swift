//
//  AppSettingsManager.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-25.
//

import Foundation

class AppSettingsManager: ObservableObject {
    //true of false to display hero card
    @Published private(set) var showHeroSectionCard = UserDefaults().bool(forKey: "showHeroSectionCard")
    
    //newest_added or latest_updated for content on the hero card
    @Published private(set) var heroSectionContent = UserDefaults().string(forKey: "heroSectionContent") ?? "newest_added"
    
    //list_view or grid_view for display of all entries
    @Published private(set) var entriesListStyle = UserDefaults().string(forKey: "entriesListStyle") ?? "list_view"
    
    func updateEntriesListStyle(listStyle: String) {
        UserDefaults().set(listStyle, forKey: "entriesListStyle")
        DispatchQueue.main.async {
            self.entriesListStyle = listStyle
        }
    }
    
    func updateHeroSectionViewAndContent(showHeroSectionCard: Bool, heroSectionContent: String) {
        UserDefaults().set(showHeroSectionCard, forKey: "showHeroSectionCard")
        UserDefaults().set(heroSectionContent, forKey: "heroSectionContent")
        DispatchQueue.main.async {
            self.showHeroSectionCard = showHeroSectionCard
            self.heroSectionContent = heroSectionContent
        }
    }
}
