//
//  Learning_Core_DataApp.swift
//  Learning Core Data
//
//  Created by Bradlee King on 30/06/2023.
//

import SwiftUI

@main
struct Learning_Core_DataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
