//
//  GeneralCache.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation

actor GeneralCache<Key: Hashable, Value> {
    private var cache: [Key: Value] = [:]
    private var accessOrder: [Key] = [] // Keeps track of access order for LRU eviction
    private let maxSize: Int

    init(maxSize: Int) {
        self.maxSize = maxSize
    }

    // Retrieve value from cache
    func getValue(forKey key: Key) -> Value? {
        if let value = cache[key] {
            // Update access order
            if let index = accessOrder.firstIndex(of: key) {
                accessOrder.remove(at: index)
            }
            accessOrder.append(key)
            return value
        }
        return nil
    }

    // Add value to cache
    func setValue(_ value: Value, forKey key: Key) {
        // If key already exists, update its value and access order
        if cache[key] != nil {
            if let index = accessOrder.firstIndex(of: key) {
                accessOrder.remove(at: index)
            }
        } else if cache.count >= maxSize {
            // Evict the least recently used item
            evictLeastRecentlyUsed()
        }

        cache[key] = value
        accessOrder.append(key)
    }

    // Remove value from cache
    func removeValue(forKey key: Key) {
        cache[key] = nil
        if let index = accessOrder.firstIndex(of: key) {
            accessOrder.remove(at: index)
        }
    }

    // Clear the entire cache
    func clear() {
        cache.removeAll()
        accessOrder.removeAll()
    }

    // Evict the least recently used item
    private func evictLeastRecentlyUsed() {
        if let leastUsedKey = accessOrder.first {
            cache.removeValue(forKey: leastUsedKey)
            accessOrder.removeFirst()
        }
    }
}

