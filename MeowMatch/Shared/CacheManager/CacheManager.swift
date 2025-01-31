//
//  CacheManager.swift
//  MeowMatch
//
//  Created by Vinsi.
//
import Foundation
import UIKit

final class CacheManager {
    static let shared = CacheManager()
    private init() {}
    let dataCache: GeneralCache<String, Data> = GeneralCache(maxSize: 100)
    let imageCache: GeneralCache<String, UIImage> = GeneralCache(maxSize: 100)
}
