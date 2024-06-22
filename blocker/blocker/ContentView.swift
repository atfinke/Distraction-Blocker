//
//  ContentView.swift
//  blocker
//
//  Created by Andrew Finke on 8/23/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var model: Model
    
    var body: some View {
        NavigationView {
            List {
                ForEach(model.items) {  item in
                    Text(item.site)
                }.onDelete { set in
                    self.model.remove(set: set)
                }
            }
            .navigationBarTitle("A.Blocker" + (model.isEnabled ? "": " (Off)"))
            .navigationBarItems(trailing: Button(action: {
                let controller = UIAlertController(
                    title: "Enter Site",
                    message: nil,
                    preferredStyle: .alert)
                controller.addTextField { _ in }
                let action = UIAlertAction(title: "Add", style: .default) { [weak controller] _ in
                    guard let controller = controller, let site = controller.textFields?.first?.text else { return }
                    self.model.add(site: site)
                }
                controller.addAction(action)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                controller.addAction(cancelAction)
                UIApplication.shared.windows.first?.rootViewController?.present(controller, animated: true, completion: nil)
            }, label: {
                Image(systemName: "plus.circle.fill").foregroundColor(.red)
            }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
