//
//  AppSettings.swift
//  AppSettingsDemo
//
//  Created by Karoly Nyisztor on 2/11/19.
//  Copyright © 2019 Karoly Nyisztor. All rights reserved.
//

import Foundation

final public class AppSettings {
    
    // MARK: - Properties
    
    /// Singleton instance
    public static let shared = AppSettings()
    
    private var settings: [String: Any] = ["Theme": "Dark",
                                           "MaxConcurrentDownloads": 4]
    
    private let serialQueue = DispatchQueue(label: "serialQueue")
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Public methods
    
    // MARK: Key getters
    
    public func string(forKey key: String) -> String? {
        var result: String?
        
        serialQueue.sync {
            result = settings[key] as? String
        }
        
        return result
    }
    
    public func int(forKey key: String) -> Int? {
        var result: Int?
        
        serialQueue.sync {
            result = settings[key] as? Int
        }
        
        return result
    }
    
    // MARK: Value setter
    
    public func set(value: Any, forKey key: String) {
        serialQueue.sync {
            settings[key] = value
        }
    }
}
