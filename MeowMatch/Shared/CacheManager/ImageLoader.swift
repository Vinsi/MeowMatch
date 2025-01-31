//
import SwiftUI

//  ImageLoader.swift
//  MeowMatch
//
//  Created by Vinsi.
//
import UIKit

struct RemoteImage: View {
    @StateObject private var loader = ImageLoader()
    @State private var isVisible = false
    let url: URL?
    let placeholder: Image

    init(url: URL?, placeholder: Image = Image(systemName: "photo")) {
        self.url = url
        self.placeholder = placeholder
    }

    var body: some View {
        ZStack {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .opacity(isVisible ? 1 : 0) // Start at 0 opacity
                    .animation(.easeIn(duration: 1), value: isVisible)
                    .onAppear {
                        isVisible = true // Triggers animation
                    }
            } else if case .loading = loader.state {
                LoaderView(color:
                    DefaultTheme()
                        .colors
                        .primary
                )
            } else if case .notStarted = loader.state {
                EmptyView()

            } else if case .completed = loader.state {
                placeholder
                    .resizable()
                    .scaledToFill()
                    .opacity(0.5)
            }
        }
        .onAppear {
            loader.loadImage(from: url)
        }.onDisappear {
            loader.cancel()
        }
    }
}

final class ImageLoader: ObservableObject {

    enum State {
        case notStarted
        case loading
        case completed
    }

    @Published var image: UIImage?
    @Published var state = State.notStarted
    private var downloadTask: Task<Void, Never>? // Task for the current image download

    func loadImage(from url: URL?) {
        guard let url = url else { return }
        let cacheKey = url.absoluteString

        // Cancel any existing task
        downloadTask?.cancel()

        // Start a new task
        downloadTask = Task {
            // Check cache first
            if let cachedImage = await CacheManager.shared.imageCache.getValue(forKey: cacheKey) {
                DispatchQueue.main.async {
                    self.image = cachedImage
                }
                return
            }

            // Download the image
            DispatchQueue.main.async {
                self.state = .loading
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard !Task.isCancelled else { return } // Handle cancellation

                if let loadedImage = UIImage(data: data) {
                    await CacheManager.shared.imageCache.setValue(loadedImage, forKey: cacheKey)
                    DispatchQueue.main.async {
                        self.image = loadedImage
                    }
                }
            } catch {
                print("Failed to load image: \(error)")
            }

            DispatchQueue.main.async {
                self.state = .completed
            }
        }
    }

    func cancel() {
        downloadTask?.cancel()
        downloadTask = nil
        state = .notStarted
    }
}
