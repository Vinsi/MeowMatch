//
//  Theme.swift
//
//
//  Created by Vinsi.
//

import SwiftUICore
import UIKit

// MARK: - **Theme Protocol** 🎨

/// Defines a theme containing typography, colors, spacing, images, and dimensions.
protocol Theme {
    var typography: Typography { get }
    var colors: ColorPalette { get }
    var spacing: Spacing { get }
    var images: Images { get }
    var dimensions: Dimensions { get }
}

// MARK: - **Typography Configuration** 🅰️

/// Defines font styles for different text elements.
struct Typography {
    let title: Font
    let mediumTitle: Font
    let body: Font

    let cellTitleLarge: Font
    let cellMedium: Font
    let cellSmall: Font

    init() {
        title = .custom("Poppins-Regular", size: 24)
        mediumTitle = .custom("Poppins-Regular", size: 14)
        body = .custom("Poppins-Regular", size: 16)
        cellTitleLarge = .custom("Poppins-SemiBold", size: 14)
        cellMedium = .custom("Poppins-Regular", size: 14)
        cellSmall = .custom("Poppins-Regular", size: 12)
    }
}

// MARK: - **Dimensions Configuration** 📏

/// Defines UI component sizes, aspect ratios, and spacing.

struct Dimensions {
    let buttonHeight: CGFloat
    let buttonWidth: CGFloat
    let iconSize: CGFloat
    let iconSizeSmall: CGFloat
    let cornerRadius: CGFloat
    let avatarSize: CGSize
    let imageAspectRatio: CGFloat
    let thumbSize: CGSize
    let cardHeight: CGFloat
    let shortBannerHeight: CGFloat

    init(
        buttonHeight: CGFloat = 44,
        buttonWidth: CGFloat = 200,
        iconSize: CGFloat = 24,
        iconSizeSmall: CGFloat = 16,
        cornerRadius: CGFloat = 8,
        avatarSize: CGSize = CGSize(width: 100, height: 100),
        thumbSize: CGSize = CGSize(width: 80, height: 80),
        imageAspectRatio: CGFloat = 16 / 9,
        cardHeight: CGFloat = 250,
        shortBannerHeight: CGFloat = 20
    ) {
        self.buttonHeight = buttonHeight
        self.buttonWidth = buttonWidth
        self.iconSize = iconSize
        self.iconSizeSmall = iconSizeSmall
        self.cornerRadius = cornerRadius
        self.avatarSize = avatarSize
        self.thumbSize = thumbSize
        self.imageAspectRatio = imageAspectRatio
        self.cardHeight = cardHeight
        self.shortBannerHeight = shortBannerHeight
    }
}

struct Spacing {
    let small: CGFloat
    let medium: CGFloat
    let large: CGFloat
    let extraLarge: CGFloat

    init(small: CGFloat = 8, medium: CGFloat = 16, large: CGFloat = 24, extraLarge: CGFloat = 32) {
        self.small = small
        self.medium = medium
        self.large = large
        self.extraLarge = extraLarge
    }
}

protocol ColorPalette {
    var primary: Color { get }
    var secondary: Color { get }
    var background: Color { get }
    var textPrimary: Color { get }
    var textSecondary: Color { get }
}

struct DefaultColorPalette: ColorPalette {
    init(primary: Color = Color(#colorLiteral(red: 0.6127355099, green: 0.1732650101, blue: 0.9525056481, alpha: 1)),
         secondary: Color = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
         background: Color = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
         textPrimary: Color = Color(#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)),
         textSecondary: Color = Color(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1))) {
        self.primary = primary
        self.secondary = secondary
        self.background = background
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
    }

    let primary: Color
    let secondary: Color
    let background: Color
    let textPrimary: Color
    let textSecondary: Color
}

struct Images {
    let backIcon = "ArrowLeft"
    let searchIcon = "Search"
    let pattern = "Pattern"
    let searchSystemIcon = "magnifyingglass"
    let settingSystemIcon = "gear"
    let listSystemIcon = "list.bullet"
    let closeSystemIcon = "xmark.circle.fill"
    let placeHolderSystemIcon = "photo"
}

struct DefaultTheme: Theme {
    var typography: Typography = .init()
    var colors: ColorPalette = DefaultColorPalette()
    var spacing: Spacing = .init()
    var images: Images = .init()
    var dimensions: Dimensions = .init(
        buttonHeight: 44,
        buttonWidth: 250,
        iconSize: 32,
        cornerRadius: 10,
        shortBannerHeight: 20
    )
}

// MARK: - **Theme Manager** 🎨

/// Manages and updates the app theme dynamically.
final class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme

    init(currentTheme: Theme = DefaultTheme()) {
        self.currentTheme = currentTheme
    }
}
