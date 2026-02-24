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
    
    private let concurrentQueue = DispatchQueue(
        label: "concurrentQueue",
        attributes: .concurrent)
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Public methods
    
    // MARK: settings value getters
    
    public func string(forKey key: String) -> String? {
        var result: String?
        
        concurrentQueue.sync {
            result = settings[key] as? String
        }
        
        return result
    }
    
    public func int(forKey key: String) -> Int? {
        var result: Int?
        
        concurrentQueue.sync {
            result = settings[key] as? Int
        }
        
        return result
    }
    
    // MARK: settings value setter
    
    public func set(value: Any, forKey key: String) {
        /// .barrier flag ensures that the queue wont execute then next block until all previous blocks have completed.
        concurrentQueue.async(flags: .barrier) {
            self.settings[key] = value
        }
    }
}
