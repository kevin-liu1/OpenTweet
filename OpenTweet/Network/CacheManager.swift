//
//  CacheManager.swift
//  OpenTweet
//
//  Created by Kevin Liu on 2024-07-17.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

protocol CacheManagerProtocol {
    func fetchDataFromCache(request: URLRequest) -> Data?
    func storeDataToCache(request: URLRequest, data: Data)
    func refreshCache()
}

class CacheManager: CacheManagerProtocol {
    public static var shared: CacheManagerProtocol = CacheManager()
    var cache: ThreadSafeDictionary<URLRequest, Data> = ThreadSafeDictionary()
    var willReturn: Bool = true
    
    func fetchDataFromCache(request: URLRequest) -> Data? {
        if willReturn {
            return cache.valueForKey(request)
        } else {
            return nil
        }
    }
    
    func storeDataToCache(request: URLRequest, data: Data) {
        cache.setValue(data, forKey: request)
    }
    
    func refreshCache() {
        cache.removeAllData()
    }
    
}

class ThreadSafeDictionary<Key: Hashable, Value> {
    private var dictionary: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "com.example.ThreadSafeDictionaryQueue", attributes: .concurrent)

    func setValue(_ value: Value, forKey key: Key) {
        queue.async(flags: .barrier) {
            self.dictionary[key] = value
        }
    }

    func valueForKey(_ key: Key) -> Value? {
        var result: Value?
        queue.sync {
            result = self.dictionary[key]
        }
        return result
    }

    func removeValueForKey(_ key: Key) {
        queue.async(flags: .barrier) {
            self.dictionary[key] = nil
        }
    }
    
    func removeAllData() {
        queue.async(flags: .barrier) {
            self.dictionary = [:]
        }
    }
}
