//
//  MovieDetails.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 30/10/2020.
//

import Foundation

struct Genre: Codable {
    var id: Int
    var name: String 
}

class MovieDetails: Codable {
    var id: Int
    var genres: [Genre]
    var poster_path: String
    var title: String
    var overview: String
    var tagline: String
    var release_date: String
}
