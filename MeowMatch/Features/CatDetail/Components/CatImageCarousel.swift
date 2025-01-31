//
//  CatImageCarousel.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import SwiftUI

struct CatImageCarousel: View {
    var images: [URL]
    var theme: Theme

    var body: some View {
        TabView {
            ForEach(images, id: \.absoluteString) { image in
                RemoteImage(url: image)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: theme.dimensions.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: theme.dimensions.cornerRadius))
        .padding(.horizontal)
    }
}
