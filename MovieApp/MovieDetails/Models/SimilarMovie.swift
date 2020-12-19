//
//  SimilarMovie.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 16.12.2020..
//

import Foundation

struct SimilarMovies: Codable {
    var similarMovies: [SimilarMovie]
    
    enum CodingKeys: String, CodingKey {
        case similarMovies = "results"
    }
}

struct SimilarMovie: Codable {
    var title: String
    var posterPath: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case posterPath = "poster_path"
    }
}
