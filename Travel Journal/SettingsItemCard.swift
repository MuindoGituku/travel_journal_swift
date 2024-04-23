//
//  SettingsItemCard.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-23.
//

import SwiftUI

struct SettingsItemCard: View {
    var iconColor: Color = .white
    var iconBackgroundColor: Color = .blue
    var iconResource: String = "plus"
    var itemTitle: String
    var itemSubtitle:String = ""
    
    var body: some View {
        HStack (alignment: .center) {
            Image(systemName: iconResource)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .font(.title3)
                .padding(8)
                .frame(width: 35, height: 35)
                .background(iconBackgroundColor)
                .foregroundStyle(iconColor)
                .cornerRadius(10)
                .padding(.trailing, 5)
            VStack (alignment: .leading) {
                Text(itemTitle)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(.black.opacity(0.8))
                    .padding(.bottom, 1)
                if !itemSubtitle.isEmpty {
                    Text(itemSubtitle)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                }
            }
            .padding(.trailing, 10)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding(.vertical)
    }
}

#Preview {
    VStack (alignment: .leading) {
        SettingsItemCard(
            iconBackgroundColor: .blue,
            iconResource: "house.fill",
            itemTitle: "Hero Section",
            itemSubtitle: "Manage the hero section display card."
        )
        .padding()
        SettingsItemCard(
            iconBackgroundColor: .green,
            iconResource: "books.vertical.fill",
            itemTitle: "Entries List",
            itemSubtitle: "Manage how the list of entries should appear on the main screen."
        )
        .padding()
        SettingsItemCard(
            iconBackgroundColor: .brown,
            iconResource: "signature",
            itemTitle: "Legal Documents"
        )
        .padding()
        SettingsItemCard(
            iconBackgroundColor: .cyan,
            iconResource: "square.and.arrow.up.fill",
            itemTitle: "Share with Friends",
            itemSubtitle: "Invite friends to download the app and enjoy."
        )
        .padding()
        SettingsItemCard(
            iconBackgroundColor: .orange,
            iconResource: "info",
            itemTitle: "About the App"
        )
        .padding()
    }
}
