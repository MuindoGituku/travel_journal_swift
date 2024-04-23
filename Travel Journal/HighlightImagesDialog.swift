//
//  HighlightImagesDialog.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-23.
//

import SwiftUI

struct HighlightImagesDialog: View {
    @Binding var currentSelectedEntryHighlight: String
    var onImageSetAsThumbnail: (String) -> Void
    let onImageDialogDismiss: () -> Void
    let uploadedHighlightImages: [String]
    @Binding var selectedImageIndex: Int
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    onImageDialogDismiss()
                }) {
                    HStack {
                        Image(systemName: "xmark.circle.fill")
                        Text("Close")
                    }
                    .padding(10)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .background(.red)
                    .cornerRadius(5)
                }
                .padding(.trailing)
            }
            TabView (
                selection: $selectedImageIndex,
                content:  {
                    ForEach(uploadedHighlightImages, id: \.self) { imageURL in
                        AsyncImage(url: URL(string: imageURL)) { thumbnail in
                            thumbnail
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(
                                    width: UIScreen.main.bounds.width * 0.9,
                                    height: UIScreen.main.bounds.height * 0.6
                                )
                                .cornerRadius(5)
                        } placeholder: {
                            Image(.emptyImageValue)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(
                                    width: UIScreen.main.bounds.width * 0.9,
                                    height: UIScreen.main.bounds.height * 0.6
                                )
                                .cornerRadius(5)
                                .overlay {
                                    Rectangle()
                                        .fill(.gray.opacity(0.5), style: FillStyle())
                                        .cornerRadius(5)
                                        .overlay {
                                            ProgressView()
                                        }
                                }
                        }
                        .tabItem {
                            Label("Caption", systemImage: "\(uploadedHighlightImages.firstIndex(of: imageURL)! + 1).circle")
                        }
                        .tag(uploadedHighlightImages.firstIndex(of: imageURL)!)
                    }
                }
            )
            .frame(
                height: UIScreen.main.bounds.height * 0.65
            )
            .tabViewStyle(.page(indexDisplayMode: .never))
            Spacer()
            if selectedImageIndex != uploadedHighlightImages.count {
                HStack {
                    ForEach (uploadedHighlightImages.indices, id: \.self) { index in
                        Rectangle()
                            .frame(width: selectedImageIndex == index ? 35 : 10, height: 10)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                            .foregroundStyle(.blue.opacity(selectedImageIndex == index ? 1.0 : 0.5))
                            .onTapGesture {
                                selectedImageIndex = index
                            }
                    }
                }
            }
            Spacer()
            Button(
                action: {
                    currentSelectedEntryHighlight = uploadedHighlightImages[selectedImageIndex]
                    onImageSetAsThumbnail(uploadedHighlightImages[selectedImageIndex])
                },
                label: {
                    HStack {
                        Image(systemName: currentSelectedEntryHighlight == uploadedHighlightImages[selectedImageIndex] ? "checkmark.circle" : "checkmark")
                            .padding(.trailing, 10)
                        Text(currentSelectedEntryHighlight == uploadedHighlightImages[selectedImageIndex] ? "Current Selected Thumbnail" : "Use As Entry Thumbnail")
                    }
                    .padding()
                }
            )
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(currentSelectedEntryHighlight == uploadedHighlightImages[selectedImageIndex] ? .gray : .blue)
            .cornerRadius(10)
            .padding()
            Spacer()
        }
        .animation(.spring(), value: selectedImageIndex)
    }
}

#Preview {
    HighlightImagesDialog (
        currentSelectedEntryHighlight: .constant("https://firebasestorage.googleapis.com:443/v0/b/travel-journal-d10c2.appspot.com/o/highlights%2F8K8x64Mu9BwOginp69Dg%2F8BC5118F-B390-4736-B952-F94308762A33.jpg?alt=media&token=9eb12aa5-551e-4728-a5d7-c9b432f12274"),
        onImageSetAsThumbnail: { imageURL in },
        onImageDialogDismiss: { },
        uploadedHighlightImages: [
            "https://firebasestorage.googleapis.com:443/v0/b/travel-journal-d10c2.appspot.com/o/highlights%2F8K8x64Mu9BwOginp69Dg%2F8BC5118F-B390-4736-B952-F94308762A33.jpg?alt=media&token=9eb12aa5-551e-4728-a5d7-c9b432f12274",
            "https://firebasestorage.googleapis.com:443/v0/b/travel-journal-d10c2.appspot.com/o/highlights%2F8K8x64Mu9BwOginp69Dg%2FCA518A7C-9840-47E0-8CF7-448F949B6A2C.jpg?alt=media&token=4c7197a2-c803-496d-bc3c-f672c91f5b1c",
            "https://firebasestorage.googleapis.com:443/v0/b/travel-journal-d10c2.appspot.com/o/highlights%2F8K8x64Mu9BwOginp69Dg%2FBB048908-6601-460C-AC78-CF39DD856C47.jpg?alt=media&token=e17949d4-95da-427c-889f-0765018519d3",
            "https://firebasestorage.googleapis.com:443/v0/b/travel-journal-d10c2.appspot.com/o/highlights%2F8K8x64Mu9BwOginp69Dg%2F435C7A95-1571-49FD-9650-8E7011558FEB.jpg?alt=media&token=e463b34d-6dca-4f32-96e2-90a6338304f4",
            "https://firebasestorage.googleapis.com:443/v0/b/travel-journal-d10c2.appspot.com/o/highlights%2F8K8x64Mu9BwOginp69Dg%2FEEA39313-4309-4BC0-8697-F25B2E05DFE1.jpg?alt=media&token=28eaeab1-9a07-47ef-ad3a-4fd2caf24e32"
        ], selectedImageIndex: .constant(0)
    )
}
