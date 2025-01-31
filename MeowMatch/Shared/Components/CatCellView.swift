//
//  CatCellView.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import SwiftUI

struct ImageHelper: View {
    var url: URL?
    var theme: Theme

    @ViewBuilder
    private func noImage() -> some View {
        Image(systemName: theme.images.placeHolderSystemIcon)
            .resizable()
            .scaledToFit()
            .foregroundColor(.gray)
    }

    var body: some View {

        RemoteImage(
            url: url
        )
        .frame(width: theme.dimensions.thumbSize.width, height: theme.dimensions.thumbSize.height)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: theme.dimensions.cornerRadius))
    }
}

struct CatCellView: View {
    let viewData: ListViewDataType
    let theme: Theme

    var body: some View {
        VStack(spacing: theme.spacing.medium) {
            HStack(alignment: .top, spacing: theme.spacing.medium) {
                ImageHelper(url: viewData.breedImageURL, theme: theme)

                VStack(alignment: .leading, spacing: theme.spacing.small) {
                    Text(viewData.breedName)
                        .font(.title.bold())
                        .foregroundColor(.primary)

                    Text(viewData.breedTemperament)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    HStack {
                        Text(Localized.Breed.origin(viewData.breedOrigin))
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Spacer()

                        Text(Localized.Breed.lifeSpan(viewData.breedLifeSpan))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            HStack {
                Text(viewData.breedDescription)
                    .font(.footnote)
                    .foregroundColor(.primary)
                Spacer()
            }
        }
        .padding([.top, .bottom], theme.spacing.small)
    }
}

#Preview {
    CatCellView(viewData: CatBreed.mock(), theme: DefaultTheme())
}
