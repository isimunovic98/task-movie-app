//
//  MovieRepresantable.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 26.11.2020..
//

import Foundation

class MovieRepresentable {
    var id: Int
    var title: String
    var overview: String
    var posterPath: String
    var releaseDate: String
    var genres: [Genre]?
    var tagline: String?
    var watched: Bool
    var favourite: Bool
    
    init(_ movie: Movie) {
        self.id = Int(movie.id)
        self.title = movie.title
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
        self.genres = nil
        self.tagline = nil
        self.watched = false
        self.favourite = false
    }
    
    init(_ movieEntity: MovieEntity) {
        self.id = Int(movieEntity.id)
        self.title = movieEntity.title!
        self.overview = movieEntity.overview!
        self.posterPath = movieEntity.posterPath!
        self.releaseDate = movieEntity.releaseDate!
        self.genres = nil
        self.tagline = nil
        self.watched = movieEntity.watched
        self.favourite =  movieEntity.favourite
    }
    
    init(_ movieDetails: MovieDetails) {
        self.id = movieDetails.id
        self.title = movieDetails.title
        self.overview = movieDetails.overview
        self.posterPath = movieDetails.posterPath
        self.releaseDate = movieDetails.releaseDate
        self.genres = movieDetails.genres
        self.tagline = movieDetails.tagline
        self.watched = false
        self.favourite = false
    }
}
