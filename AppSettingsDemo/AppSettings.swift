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
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Public methods
    
    // MARK: Key getters
    
    public func string(forKey key: String) -> String? {
        return settings[key] as? String
    }
    
    public func int(forKey key: String) -> Int? {
        return settings[key] as? Int
    }
}
