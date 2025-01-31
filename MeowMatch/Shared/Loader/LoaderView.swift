//
//  LoaderView.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import SwiftUI

struct LoaderView: View {
    let color: Color
    let size: CGFloat
    @State private var isRotated: Bool = false
    private let animation = Animation.linear.repeatForever(autoreverses: false)

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(color, lineWidth: 4)
            .square(size: size)
            .rotationEffect(.degrees(isRotated ? 360 : 0))
            .animation(animation, value: isRotated)
            .onAppear {
                DispatchQueue.main.async {
                    isRotated.toggle()
                }
            }
    }
}

extension LoaderView {

    init(color: Color, width: CGFloat = 20) {
        self.color = color
        size = width
    }
}

#Preview {
    LoaderView(color: Color.red)
}
