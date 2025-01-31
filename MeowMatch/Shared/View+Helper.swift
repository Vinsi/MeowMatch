//
//  View+Helper.swift
//  MeowMatch
//
//  Created by Vinsi.
//
import SwiftUI

extension View {
    @ViewBuilder
    func square(size: CGFloat) -> some View {
        frame(width: size, height: size)
    }
}
