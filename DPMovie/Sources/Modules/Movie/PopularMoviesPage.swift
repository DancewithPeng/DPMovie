//
//  PopularMoviesPage.swift
//  DPMovie
//
//  Created by Peter Zhang on 2025/3/26.
//

import SwiftUI

struct PopularMoviesPage: View {
    
    @StateObject var movies = PopularMovies()
    @EnvironmentObject var configurations: AppConfiguration
    
    var body: some View {
        itemList
            .navigationTitle("Popular Movies")
    }
    
    var itemList: some View {
        List(Array(movies.items.enumerated()), id: \.element.id) { index, movie in
            ItemView(index: index, movie: movie)
                .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .listRowSpacing(20)
    }
}

extension PopularMoviesPage {
    
    struct ItemView: View {
        let index: Int
        let movie: MovieSummary
        
        var body: some View {
            HStack(spacing: 8) {
                cover
                infoContent
            }
            .frame(height: 100)
        }
        
        var cover: some View {
            MovieImage(path: movie.posterPath)
                .frame(width: 67, height: 100)
                .clipShape(.rect(cornerRadius: 8))
        }
        
        var infoContent: some View {
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    introduction
                    Spacer(minLength: 8)
                    rankIndicator
                }
                Spacer(minLength: 10)
                extensionInfo
            }
            .padding(.vertical, 4)
        }
        
        var introduction: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.system(size: 18, weight: .semibold))
                    .lineLimit(1)
                if (movie.overview.count > 0) {
                    Text(movie.overview)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.primary.opacity(0.8))
                        .lineLimit(2)
                }
            }
        }
        
        var rankIndicator: some View {
            Text("\(index + 1)")
                .frame(width: 30, height: 30)
                .background {
                    Capsule()
                        .fill(Color.cyan.opacity(0.4))
                }
        }
        
        var extensionInfo: some View {
            HStack {
                Text(movie.releaseDate)
                Spacer()

                ValueField(icon: "star", value: Decimal(movie.voteAverage))
                ValueField(icon: "hand.point.up.left", value: Decimal(movie.voteCount))
                ValueField(icon: "flame", value: Decimal(movie.popularity))
            }
            .font(.system(size: 14))
            .foregroundStyle(Color.primary.opacity(0.5))
        }
    }
    
    struct ValueField: View {
        
        let icon: String
        let value: Decimal
        
        var body: some View {
            HStack(spacing: 4) {
                Image(systemName: icon)
                Text(value.formatted(.number.precision(.fractionLength(0...1))))
            }
            .font(.system(size: 14))
            .foregroundStyle(Color.primary.opacity(0.5))
        }
    }
}

#Preview {
    NavigationStack {
        PopularMoviesPage()
    }
}
