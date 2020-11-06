//
//  MovieNowPlaying.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 30/10/2020.
//

import Foundation

struct MovieResponse: Codable {
    var results: [Movie]
}

struct Movie: Codable {
    var id: Int
    var title: String
    var overview: String
    var poster_path: String
    var release_date: String
}


