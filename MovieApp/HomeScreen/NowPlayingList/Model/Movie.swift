//
//  MovieNowPlaying.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 30/10/2020.
//

import Foundation

struct Movies: Codable {
    var results: [Movie]
}

struct Movie: Codable {
    var id: Int
    var title: String
    var overview: String
    var posterPath: String
    var releaseDate: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}


