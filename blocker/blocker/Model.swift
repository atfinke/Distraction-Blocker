//
//  Model.swift
//  blocker
//
//  Created by Andrew Finke on 8/23/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation
import SafariServices
import SwiftUI

class Model: ObservableObject {
    
    // MARK: - Properties -
    
    @Published private(set) var items = [BlockedItem]()
    
    private var data: Data? {
        get {
            return keyValueStore.data(forKey: Model.key)
        }
        set {
            keyValueStore.set(newValue, forKey: Model.key)
            keyValueStore.synchronize()
            updateContentBlocker()
        }
    }
    
    private static let key = "ModelKey"
    private let keyValueStore = NSUbiquitousKeyValueStore.default
    
    // MARK: - Initalization -
    
    init() {
        updateItemsFromData()
        updateContentBlocker()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyValueStoreChanged(_:)),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: keyValueStore)
    }
    
    // MARK: - Helpers -
    
    @objc
    private func keyValueStoreChanged(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let reasonForChange = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey] as? NSNumber  else {
            return
        }
        
        let reason = reasonForChange.intValue
        if reason == NSUbiquitousKeyValueStoreServerChange || reason == NSUbiquitousKeyValueStoreInitialSyncChange {
            DispatchQueue.main.async {
                self.updateItemsFromData()
                self.updateContentBlocker()
            }
        }
    }
    
    private func updateItemsFromData() {
        guard let data = data, let items = try? JSONDecoder().decode([BlockedItem].self, from: data) else {
            return
        }
        self.items = items
    }
    
    private func updateDataFromItems() {
        guard let data = try? JSONEncoder().encode(items) else {
            return
        }
        self.data = data
    }
    
    func add(site: String) {
        DispatchQueue.main.async {
            self.items.append(.init(site: site))
            self.updateDataFromItems()
        }
    }
    
    func remove(set: IndexSet) {
        DispatchQueue.main.async {
            self.items.remove(atOffsets: set)
            self.updateDataFromItems()
        }
    }
    
    private func updateContentBlocker() {
        guard let defaults = UserDefaults(suiteName: "group.com.andrewfinke.test") else {
            fatalError()
        }
        defaults.set(data, forKey: "data")
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: "com.andrewfinke.blocker.extension") { _ in }
    }
}
