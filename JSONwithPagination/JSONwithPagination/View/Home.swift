//
//  Home.swift
//  JSONwithPagination
//
//  Created by Adrian Suryo Abiyoga on 20/01/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    /// View Properties
    @State private var photos: [Photo] = []
    @State private var isLoading: Bool = false
    /// Pagination Properties
    @State private var page: Int = 1
    @State private var lastFetchedPage: Int = 1
    @State private var maxPage: Int = 5
    @State private var activePhotoID: String?
    @State private var lastPhotoID: String?
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3), spacing: 10) {
                ForEach(photos) { photo in
                    PhotoCardView(photo: photo)
                }
            }
            .overlay(alignment: .bottom) {
                if isLoading {
                    ProgressView()
                        .offset(y: 30)
                }
            }
            .padding(15)
            .padding(.bottom, 15)
            .scrollTargetLayout()
        }
        .scrollPosition(id: Binding<String?>.init(get: {
            return ""
        }, set: { newValue in
            activePhotoID = newValue
        }), anchor: .bottomTrailing)
        .onChange(of: activePhotoID, { oldValue, newValue in
            if newValue == lastPhotoID, !isLoading, page != maxPage {
                page += 1
                print("Fetching Page \(page)")
                fetchPhotos()
            }
        })
        .onAppear {
            if photos.isEmpty { fetchPhotos() }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Increase Page limit to 8") {
                        maxPage = 8
                    }
                } label: {
                    Image(systemName: "slider.horizontal.below.rectangle")
                }
            }
        }
    }
    
    /// Fetching Photos as per needs
    func fetchPhotos() {
        Task {
            do {
                if let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=30") {
                    isLoading = true
                    
                    let session = URLSession(configuration: .default)
                    let jsonData = try await session.data(from: url).0
                    let photos = try JSONDecoder().decode([Photo].self, from: jsonData)
                    /// Updating UI in Main Thread
                    await MainActor.run {
                        if photos.isEmpty {
                            /// No More Data
                            page = lastFetchedPage
                            /// Optional: You can set the maxPage to lastFetchedPage so that it won't try to fetch more items when it reaches the end.
                            /// maxPage = lastFetchedPage
                        } else {
                            /// Adding to the Array of Photos
                            self.photos.append(contentsOf: photos)
                            lastPhotoID = self.photos.last?.id
                            lastFetchedPage = page
                        }
                        
                        isLoading = false
                    }
                }
            } catch {
                isLoading = false
                lastFetchedPage = page
                print(error.localizedDescription)
            }
        }
    }
}

/// Photo Card View
struct PhotoCardView: View {
    var photo: Photo
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            GeometryReader {
                let size = $0.size
                
                AnimatedImage(url: photo.imageURL) {
                    ProgressView()
                    /// To Place Indicator at center
                        .frame(width: size.width, height: size.height)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipShape(.rect(cornerRadius: 10))
            }
            .frame(height: 120)
            
            /// Author Name
            Text(photo.author)
                .font(.caption)
                .foregroundStyle(.gray)
                .lineLimit(1)
            
            /// You can add other properties, such as links, etc.
        })
    }
}

#Preview {
    ContentView()
}

