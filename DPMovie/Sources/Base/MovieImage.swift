//
//  MovieImage.swift
//  DPMovie
//
//  Created by Peter Zhang on 2025/3/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieImage: View {
    
    let path: String
    
    @Environment(\.displayScale) var displayScale
    
    var url: URL? {
        if let configurations = AppState.shared.configurations {
            return URL(string: configurations.image.secureBaseURL + configurations.optimalPosterSize(for: (UIScreen.main.bounds.width / 2.0) * displayScale) + path)
        } else {
            return nil
        }
    }
    
    init(path: String) {
        self.path = path
    }

    var body: some View {
        WebImage(url: url, scale: displayScale, context: [.imageThumbnailPixelSize: CGSize(width: 100 * displayScale, height: 100 * displayScale)])
            .resizable()
            .scaledToFill()
            .onTapGesture {
                Log.debug("\(url?.absoluteString ?? "") - \((UIScreen.main.bounds.width / 2.0) * displayScale) - \(displayScale)")
            }
    }
}

#Preview {
    MovieImage(path: "")
}
