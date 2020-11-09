//
//  Movies.swift
//  Tickled
//
//  Created by Sachitananda Sahu on 07/11/20.
//

import Foundation

// MARK: - Movie List
struct MoviesList: Decodable {
    let page: Int?
    let results: [Movie]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case results = "results"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int.self, forKey: .page)
        self.totalPages = try container.decode(Int.self, forKey: .totalPages)
        self.totalResults = try container.decode(Int.self, forKey: .totalResults)
        self.results = try container.decode([Movie].self, forKey: .results)
      }
}

// MARK: - Movies
struct Movie: Decodable {
    let id: Int?
    let video: Bool?
    let voteCount: Int?
    let voteAverage: Double?
    let title, releaseDate: String?
    let originalLanguage: String??
    let originalTitle: String?
    let genreIDS: [Int]?
    let backdropPath: String?
    let adult: Bool?
    let overview, posterPath: String?
    let popularity: Double?
    let mediaType: String?
    
    enum ResultKeys: String, CodingKey {
        case id, video, title, adult, overview, popularity
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case mediaType = "media_type"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        video = try container.decode(Bool.self, forKey: .video)
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        title = try container.decode(String.self, forKey: .title)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        genreIDS = try container.decode([Int].self, forKey: .genreIDS)
        backdropPath = try container.decode(String.self, forKey: .backdropPath)
        adult = try container.decode(Bool.self, forKey: .adult)
        overview = try container.decode(String.self, forKey: .overview)
        posterPath = try container.decode(String.self, forKey: .posterPath)
        popularity = try container.decode(Double.self, forKey: .popularity)
        mediaType = try container.decode(String.self, forKey: .mediaType)
    }
}
