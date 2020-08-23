//
//  ContentBlockerRequestHandler.swift
//  extension
//
//  Created by Andrew Finke on 8/23/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
    
    func beginRequest(with context: NSExtensionContext) {
        guard let defaults = UserDefaults(suiteName: "group.com.andrewfinke.test"),
            let data = defaults.data(forKey: "data") else {
            return
        }
     
        let path = NSTemporaryDirectory().appending("\(UUID().uuidString)-block.json")
        let url = URL(fileURLWithPath: path)
        do {
            try data.write(to: url)
        } catch {
            return
        }
        
        guard let attachment = NSItemProvider(contentsOf: url) else {
            return
        }
        
        let item = NSExtensionItem()
        item.attachments = [attachment]
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
    
}
