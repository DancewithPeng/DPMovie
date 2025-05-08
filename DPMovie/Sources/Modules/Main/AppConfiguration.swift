//
//  AppConfiguration.swift
//  DPMovie
//
//  Created by Peter Zhang on 2025/3/26.
//

import Foundation
import Combine
import SwiftData

/// 应用配置
@Model
final class AppConfiguration: ObservableObject, Codable, CustomDebugStringConvertible {
    var image: ImageConfiguration
    
    init(image: ImageConfiguration) {
        self.image = image
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try container.decode(ImageConfiguration.self, forKey: .image)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(image, forKey: .image)
    }
    
    enum CodingKeys: String, CodingKey {
        case image = "images"
    }
    
    var debugDescription: String {
        """
        \(type(of: self)): \(ObjectIdentifier(self))
            image: \(image.debugDescription)
        """
    }
    
    @Model class ImageConfiguration: Codable, CustomDebugStringConvertible {
        var baseURL: String
        var secureBaseURL: String
        var backdropSizes: [String]
        var logoSizes: [String]
        var posterSizes: [String]
        var profileSizes: [String]
        var stillSizes: [String]
        
        @Transient
        lazy var posterWidthSizes: [(String, CGFloat)] = {
            posterSizes.compactMap { size -> (String, CGFloat)? in
                if size.hasPrefix("w"), let width = Double(size.dropFirst()) {
                    return (size, CGFloat(width))
                }
                return nil
            }
        }()
        
        init(
            baseURL: String,
            secureBaseURL: String,
            backdropSizes: [String],
            logoSizes: [String],
            posterSizes: [String],
            profileSizes: [String],
            stillSizes: [String]
        ) {
            self.baseURL = baseURL
            self.secureBaseURL = secureBaseURL
            self.backdropSizes = backdropSizes
            self.logoSizes = logoSizes
            self.posterSizes = posterSizes
            self.profileSizes = profileSizes
            self.stillSizes = stillSizes
        }
        
        required init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.baseURL = try container.decode(String.self, forKey: .baseURL)
            self.secureBaseURL = try container.decode(String.self, forKey: .secureBaseURL)
            self.backdropSizes = try container.decode([String].self, forKey: .backdropSizes)
            self.logoSizes = try container.decode([String].self, forKey: .logoSizes)
            self.posterSizes = try container.decode([String].self, forKey: .posterSizes)
            self.profileSizes = try container.decode([String].self, forKey: .profileSizes)
            self.stillSizes = try container.decode([String].self, forKey: .stillSizes)
        }
        
        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(baseURL, forKey: .baseURL)
            try container.encode(secureBaseURL, forKey: .secureBaseURL)
            try container.encode(backdropSizes, forKey: .backdropSizes)
            try container.encode(logoSizes, forKey: .logoSizes)
            try container.encode(posterSizes, forKey: .posterSizes)
            try container.encode(profileSizes, forKey: .profileSizes)
            try container.encode(stillSizes, forKey: .stillSizes)
        }

        enum CodingKeys: String, CodingKey {
            case baseURL = "base_url"
            case secureBaseURL = "secure_base_url"
            case backdropSizes = "backdrop_sizes"
            case logoSizes = "logo_sizes"
            case posterSizes = "poster_sizes"
            case profileSizes = "profile_sizes"
            case stillSizes = "still_sizes"
        }
        
        var debugDescription: String {
            """
            \(type(of: self)): \(ObjectIdentifier(self))
                baseURL: \(baseURL)
                secureBaseURL: \(secureBaseURL)
                backdropSizes: \(backdropSizes)
                logoSizes: \(logoSizes)
                posterSizes: \(posterSizes)
                profileSizes: \(profileSizes)
                stillSizes: \(stillSizes)
                posterWidthSizes: \(posterWidthSizes)
            """
        }
    }
}

extension AppConfiguration {
    
    func optimalPosterSize(for width: CGFloat) -> String {
        Log.debug("\(String(describing: ObjectIdentifier(self.image))) - \(String(describing: self.image.posterWidthSizes))")
        let maxDisdance = image.posterWidthSizes.reduce(0) { partialResult, size in
            let d = abs(size.1 - width)
            return d > partialResult ? d : partialResult
        }
        if let minDisdanceSize = image.posterWidthSizes.min(by: { abs($0.1 - width) < abs($1.1 - width) }) {
            if abs(minDisdanceSize.1 - width) < maxDisdance {
                return minDisdanceSize.0
            } else {
                return "original"
            }
        } else {
            return "original"
        }
    }
}

extension AppConfiguration {
    
    func saveToLocal() async throws {
        let context = ModelContext(await AppState.shared.modelContainer)
        try context.delete(model: AppConfiguration.self)
        context.insert(self)
        try context.save()
    }
    
    static func loadFromLocal() async throws -> AppConfiguration? {
        let context = ModelContext(await AppState.shared.modelContainer)
        let descriptor = FetchDescriptor<AppConfiguration>()
        let result = try context.fetch(descriptor)
        return result.first
    }
}

