//
//  AppState.swift
//  DPMovie
//
//  Created by Peter Zhang on 2025/3/26.
//

import Foundation
import Combine
import Alamofire
import SwiftData

/// 应用状态
@MainActor class AppState: ObservableObject {
    
    @Published var isInitialLoading: Bool = true
    @Published var configurations: AppConfiguration?
    
    let modelContainer: ModelContainer
    
    static let shared = AppState()
    private init() {
        
        do {
            let modelConfiguration = ModelConfiguration(for: AppConfiguration.self, isStoredInMemoryOnly: false)
            modelContainer = try ModelContainer(for: AppConfiguration.self, configurations: modelConfiguration)
        } catch {
            Log.error("\(error.localizedDescription)")
            fatalError(error.localizedDescription)
        }
        
        loadInitialData()
    }
}

extension AppState {
    
    func loadInitialData() {
        Task {
            isInitialLoading = true
            do {
                
                if let localConfigurations = try await AppConfiguration.loadFromLocal() {
                    self.configurations = localConfigurations
                    Log.info("加载本地配置成功: \(String(describing: localConfigurations.debugDescription))")
                    updateConfigurationFromServer()
                } else {
                    let configuration = try await MovieAPI.fetchConfiguration()
                    try await configuration.saveToLocal()
                    self.configurations = configuration
                    Log.info("加载网络配置成功: \(String(describing: configuration.debugDescription))")
                }
                
                isInitialLoading = false
            } catch {
                Log.error("\(error.localizedDescription)")
                isInitialLoading = false
            }
        }
    }
    
    func updateConfigurationFromServer() {
        Task {
            do {
                let configuration = try await MovieAPI.fetchConfiguration()
                try await configuration.saveToLocal()
                self.configurations = configuration
                Log.info("更新网络配置成功: \(String(describing: configuration.debugDescription))")
            } catch {
                Log.error("\(error.localizedDescription)")
            }
        }
    }
}
