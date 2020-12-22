//
//  Constants.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 03/11/2020.
//

import UIKit

struct Constants {
    static var CELL_SPACING: CGFloat = 15
    
    static func poster(path posterPath: String) -> String {
        return "https://image.tmdb.org/t/p/w500/\(posterPath)"
    }
    
    static var ALL_MOVIES_URL: String = "https://api.themoviedb.org/3/movie/now_playing?api_key=aaf38b3909a4f117db3fb67e13ac6ef7&language=en-US&page=1"

    static func movieDetails(of id: Int) -> String {
        return "https://api.themoviedb.org/3/movie/\(id)?api_key=aaf38b3909a4f117db3fb67e13ac6ef7&language=en-US"
    }
    
    static func similarMovies(of id: Int) -> String {
        return "https://api.themoviedb.org/3/movie/\(id)/similar?api_key=aaf38b3909a4f117db3fb67e13ac6ef7&language=en-US&page=1"
    }
}
