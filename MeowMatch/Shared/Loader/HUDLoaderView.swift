//
//  HUDLoaderView.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import SwiftUI

struct HUDLoaderView: View {
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        ZStack {

            Rectangle()
                .fill(Color.white)
                .frame(width: 50, height: 50)
                .background(Color.blue)
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
            LoaderView(color: themeManager.currentTheme.colors.primary)
        }
    }
}

#Preview {
    HUDLoaderView().environmentObject(ThemeManager())
}
