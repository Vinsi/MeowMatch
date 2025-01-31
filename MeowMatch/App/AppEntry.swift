//
//  AppEntry.swift
//  AppEntry
//
//  Created by Vinsi.
//

import SwiftUI

@main
struct AppEntry: App {
    @StateObject var router = Router()
    @StateObject var themeManager = ThemeManager()
    let internetConnectivityChecker = InternetConnectivityChecker.shared

    init() {
        applyNavigationBarStyle()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                RootView().navigateUsingRouter()
            }
            .environmentObject(AppEnvironment.shared)
            .environmentObject(themeManager)
            .environmentObject(router)
            .environmentObject(internetConnectivityChecker)
            .preferredColorScheme(.light)
        }
    }

    private func applyNavigationBarStyle() {
        let appearance = UINavigationBarAppearance()
        let colors = themeManager.currentTheme.colors
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: colors.primary.toUIColor ?? .purple]
        appearance.largeTitleTextAttributes = [.foregroundColor: colors.primary.toUIColor ?? .purple]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct RootView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var internet: InternetConnectivityChecker
    @EnvironmentObject var router: Router

    var body: some View {
        ZStack {
            TabView {
                Router.Destination.list.toView

                Router.Destination.search.toView
            }
            .accentColor(themeManager.currentTheme.colors.primary)

            if internet.isConnected == false {
                Text(Localized.Error.noInternetConnection).frame(height: 20) // TODO: -Need to work on
                    .padding()
                    .foregroundColor(themeManager.currentTheme.colors.secondary)
                    .background(RoundedRectangle(cornerRadius: themeManager.currentTheme.dimensions.cornerRadius)
                        .fill(themeManager.currentTheme.colors.primary))
            }
        }
    }
}
