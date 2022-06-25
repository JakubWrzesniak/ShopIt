//
//  ShopItApp.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 01/12/2021.
//

import SwiftUI

@main
struct ShopItApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
