//
//  MovieListParameters.swift
//  DPMovie
//
//  Created by Peter Zhang on 2025/3/26.
//

import Foundation

struct MovieListParameters: APIParameters {
    let page: Int
    let language: String
    
    init(page: Int, language: String = Locale.current.language.languageCode?.identifier ?? "en-US") {
        self.page = page
        self.language = language
    }
}
