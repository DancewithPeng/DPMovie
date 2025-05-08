//
//  DPMovieApp.swift
//  DPMovie
//
//  Created by Peter Zhang on 2025/3/26.
//

import SwiftUI

@main
struct DPMovieApp: App {
    
    @StateObject var appState = AppState.shared    
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .environmentObject(appState)
        .modelContainer(appState.modelContainer)
        .modelContext(appState.modelContainer.mainContext)
    }
}
