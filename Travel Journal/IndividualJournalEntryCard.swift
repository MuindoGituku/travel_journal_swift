//
//  IndividualJournalEntryCard.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-18.
//

import SwiftUI

struct IndividualJournalEntryCard: View {
    let entry: JournalEntry
    
    var body: some View {
        VStack (alignment: .leading) {
            if entry.entryThumbnail.isEmpty {
                Image(.emptyImageValue)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .cornerRadius(10)
                    .overlay {
                        Rectangle()
                            .fill(.gray.opacity(0.5), style: FillStyle())
                            .cornerRadius(10)
                    }
            } else {
                AsyncImage(url: URL(string: entry.entryThumbnail)) { thumbnail in
                    thumbnail
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .cornerRadius(10)
                } placeholder: {
                    Image(.emptyImageValue)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .cornerRadius(10)
                        .overlay {
                            Rectangle()
                                .fill(.gray.opacity(0.5), style: FillStyle())
                                .cornerRadius(10)
                                .overlay {
                                    ProgressView()
                                }
                        }
                }
            }
            Text(entry.travelLocation.components(separatedBy: ",").first ?? "Town")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.bottom, 2)
            Text(entry.travelStartDate.formatted(date: .abbreviated, time: .omitted))
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(.gray)
        }
    }
}
