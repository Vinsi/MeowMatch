//
//  CatListView.swift
//  MeowMatch
//
//  Created by Vinsi.
//
import SwiftUI

struct CatListView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var themeManager: ThemeManager
    let breeds: [any ListViewDataType]
    var onTap: ((ListViewDataType) -> Void)?
    var onAppear5thLastElement: (() -> Void)?
    var body: some View {
        List(breeds, id: \.breedID) { breed in
            CatCellView(
                viewData: breed,
                theme: themeManager.currentTheme
            )
            .onAppear {
                guard breeds.lastNthItem(is: breed, nthIndex: 5) else {
                    logPaging.logI("Not Loding More")
                    return
                }
                onAppear5thLastElement?()
            }
            .onTapGesture {
                onTap?(breed)
            }
        }
        .listRowSeparatorTint(.clear)
        .listStyle(PlainListStyle())
    }
}

#Preview {
    CatListView(breeds: [CatBreed.mock(), CatBreed.mock(id: "2")])
        .environmentObject(AppEnvironment.shared)
        .environmentObject(Router())
        .environmentObject(ThemeManager())
}

private extension [any ListViewDataType] {
    func lastNthItem(is object: Element, nthIndex: Int) -> Bool {
        suffix(nthIndex).first?.breedID == object.breedID
    }
}
