//
//  SearchBarView.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import SwiftUI

struct PlaceholderStyle: ViewModifier {
    var showPlaceholder: Bool
    var placeholder: String
    var placeholderColor: Color

    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceholder {
                Text(placeholder)
                    .foregroundColor(placeholderColor)
            }
            content
                .foregroundColor(.primary)
        }
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var isLoading: Bool
    @FocusState private var isFocused: Bool
    let placeholder: String
    let theme: Theme

    var body: some View {
        HStack {
            if !isLoading {
                Image(theme.images.searchIcon)
                    .foregroundColor(searchText.isEmpty ? theme.colors.primary : theme.colors.primary.opacity(0.5))
                    .square(size: theme.dimensions.iconSizeSmall)
                    .onTapGesture {
                        isFocused = true
                    }
            } else {
                LoaderView(color: theme.colors.primary)
                    .square(size: theme.dimensions.iconSizeSmall)
            }

            TextField(placeholder, text: $searchText)
                .focused($isFocused)
                .foregroundColor(theme.colors.textPrimary)
                .modifier(
                    PlaceholderStyle(showPlaceholder: searchText.isEmpty,
                                     placeholder: placeholder,
                                     placeholderColor: .gray)
                )
                .autocorrectionDisabled(true)
                .font(theme.typography.mediumTitle)

            Image(systemName: theme.images.closeSystemIcon)
                .padding(0)
                .offset(x: 0)
                .tint(theme.colors.primary)
                .foregroundColor(theme.colors.primary)
                .opacity(searchText.isEmpty ? 0.0 : 1.0)
                .square(size: theme.dimensions.iconSizeSmall)
                .onTapGesture {
                    searchText = ""
                }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: theme.dimensions.cornerRadius)
                .fill(theme.colors.background)
                .shadow(
                    color: theme.colors.primary.opacity(1),
                    radius: 2,
                    x: 0,
                    y: 0
                )
        )
        .padding(.horizontal, theme.spacing.medium)
        .padding([.bottom], .zero)
    }
}

#Preview {
    SearchBarView(
        searchText: .constant("h"),
        isLoading: .constant(false),
        placeholder: "Search",
        theme: DefaultTheme()
    )
}
