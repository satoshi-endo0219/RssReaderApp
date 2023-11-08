//
//  RssReaderApp.swift
//  RssReaderApp
//
//  Created by satoshi on 2023/11/02.
//

import SwiftUI

@main
struct RssReaderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LaunchScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
