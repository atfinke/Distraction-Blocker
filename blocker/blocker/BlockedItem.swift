//
//  BlockedItem.swift
//  blocker
//
//  Created by Andrew Finke on 8/23/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

struct BlockedItem: Codable, Identifiable {
    
    // MARK: - Properties -
    
    var id = UUID().uuidString
    let action: [String: String]
    let trigger: [String: String]
    let site: String
    
    // MARK: - Initalization -
    
    init(site: String) {
        self.site = site
        action = ["type": "block"]
        trigger = ["url-filter": site]
    }
}
