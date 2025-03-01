//
//  AppEntry.swift
//  AppEntry
//
//  Created by Vinsi.
//

import SwiftUI

/// 🏁 **Main Entry Point of the App**
@main
struct AppEntry: App {

    /// 📌 **Router for Navigation Handling**
    @StateObject var router = Router()

    /// 🎨 **Theme Manager for Dark/Light Mode**
    @ObservedObject var themeManager = ThemeManager()

    /// 🌐 **Internet Connectivity Checker (Singleton)**
    let internetConnectivityChecker = InternetConnectivityCheckerImpl()

    /// 🎨 **Initialize App with Navigation Bar Styling**
    init() {
        internetConnectivityChecker.startMonitoring()
        applyNavigationBarStyle()
    }

    /// 🏠 **Main Scene - Defines the UI Structure**
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

    /// 🎨 **Apply Custom Navigation Bar Styling**
    private func applyNavigationBarStyle() {
        let appearance = UINavigationBarAppearance()
        let colors = themeManager.currentTheme.colors
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: colors.primary.toUIColor ?? .purple]
        appearance.largeTitleTextAttributes = [.foregroundColor: colors.primary.toUIColor ?? .purple]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        // swiftlint:disable line_length
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = colors.primary.toUIColor ?? .purple
        // swiftlint:enable line_length
    }
}

/***
   Note Separating as its convienice for look ups.
 */
/// 📌 **Root View - Manages Tabs & Internet Alerts**
struct RootView: View {
    /// 🎨 Access the Theme Manager
    @EnvironmentObject var themeManager: ThemeManager

    /// 🌐 Check Internet Connectivity
    @EnvironmentObject var internet: InternetConnectivityCheckerImpl

    /// 📌 Handle Navigation Routing
    @EnvironmentObject var router: Router

    /// 📌 Handle Navigation Routing
    @EnvironmentObject var environment: AppEnvironment

    var body: some View {
        ZStack {
            TabView(selection: $router.selectedTab) {
                BreedListView()
                .tag(Router.Tab.list)

                SearchView()
                .tag(Router.Tab.search)
            }

            .accentColor(themeManager.currentTheme.colors.primary)

            if internet.isConnected == false {
                let theme = themeManager.currentTheme
                // 🚨 No Internet Message
                Text(Localized.Error.noInternetConnection).frame(height: theme.dimensions.shortBannerHeight)
                    .padding()
                    .foregroundColor(theme.colors.secondary)
                    .background(RoundedRectangle(cornerRadius: theme.dimensions.cornerRadius)
                    .fill(themeManager.currentTheme.colors.primary))
            }
        }

    }
}


// MARK: - 🛠 Preview

#Preview {
    RootView()
    .environmentObject(AppEnvironment.shared)
    .environmentObject(Router())
    .environmentObject(ThemeManager())
    .environmentObject(InternetConnectivityCheckerImpl(isMock: true))
}

