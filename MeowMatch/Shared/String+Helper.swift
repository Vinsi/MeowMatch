//
//  String+Helper.swift
//  MeowMatch
//
//  Created by Vinsi.
//
import Foundation

extension String {

    var isNotEmpty: Bool {
        !isEmpty
    }

    var asURL: URL? {
        URL(string: self)
    }
}
