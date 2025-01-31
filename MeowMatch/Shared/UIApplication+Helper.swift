//
//  UIApplication+Helper.swift
//  MeowMatch
//
//  Created by Vinsi on 31/01/2025.
//

import UIKit

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
