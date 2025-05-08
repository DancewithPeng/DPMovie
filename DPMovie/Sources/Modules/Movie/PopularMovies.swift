//
//  PopularMovies.swift
//  DPMovie
//
//  Created by Peter Zhang on 2025/3/26.
//

import Foundation
import Combine

@MainActor class PopularMovies: ObservableObject {
    @Published var items: [MovieSummary] = []
    
    private var pageCursor = 1
    
    init() {
        loadInitialData()
    }
}

extension PopularMovies {
    
    /// 加载初始数据
    private func loadInitialData() {
        Task {
            do {
                try await loadFirstPageData()
            } catch {
                Log.error("\(error.localizedDescription)")
            }
        }
    }
    
    func loadFirstPageData() async throws {
        self.items = try await MovieAPI.fetchPopularMovies(page: 1)
        self.pageCursor = 1
    }
    
    func loadNextPageData() async throws {
        let nextPage = pageCursor + 1
        let newItems = try await MovieAPI.fetchPopularMovies(page: nextPage)
        self.items.append(contentsOf: newItems)
        self.pageCursor = nextPage
    }
}
