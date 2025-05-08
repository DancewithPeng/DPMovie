//
//  RootView.swift
//  DPMovie
//
//  Created by Peter Zhang on 2025/3/26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        if appState.isInitialLoading {
            ProgressView()
        } else {
            if let configurations = appState.configurations {
                NavigationStack {
                    PopularMoviesPage()
                }
                .environmentObject(configurations)
            } else {
                Text("Configuration loading error, please tap to Retry")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
                    .onTapGesture {
                        appState.loadInitialData()
                    }
            }
        }
    }
}

#Preview {
    RootView()
}
