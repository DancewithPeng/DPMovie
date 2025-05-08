//
//  APIListResult.swift
//  DPMovie
//
//  Created by Peter Zhang on 2025/3/26.
//

import Foundation

struct APIListResult<Item: Codable>: Codable {
    
    let page: Int
    let results: [Item]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
