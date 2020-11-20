//
//  Constants.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 03/11/2020.
//

import UIKit

struct Constants {
    static var CELL_SPACING: CGFloat = 15
    
    static var IMAGE_BASE_PATH: String = "https://image.tmdb.org/t/p/w500/"
    
    static var ALL_MOVIES_URL: String = "https://api.themoviedb.org/3/movie/now_playing?api_key=aaf38b3909a4f117db3fb67e13ac6ef7&language=en-US&page=1"
    
    struct MovieDetails {
        
        static var response: String = "https://api.themoviedb.org/3/movie/"
        static var apiKey: String = "?api_key=aaf38b3909a4f117db3fb67e13ac6ef7&language=en-US"
    }
}
