//
//  NowPlayingViewPresenter.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 18.11.2020..
//

import Foundation

protocol NowPlayingDelegate: class {
    func reloadScreenData()
    func loading(_ shouldShowLoader: Bool)
    func presentJsonError(_ message: String)
}

class NowPlayingPresenter {
    
    var delegate: NowPlayingDelegate!
    
    var movies: [MovieEntity] = []
    
    func getMovies(showLoader: Bool) {
        if showLoader {
            delegate.loading(true)
        }
        
        APIService.fetch(from: Constants.ALL_MOVIES_URL, of: Movies.self) { (moviesResponse, message) in
            guard let moviesResponse = moviesResponse?.results else {
                self.delegate.presentJsonError(message)
                return
            }
            self.createScreenData(from: moviesResponse)
            self.delegate.reloadScreenData()
        }
        
        if showLoader {
            delegate.loading(false)
        }
    }
    
    //Takes all the movies from api call, if that movie exists in Core Data its just appended,
    // if not its properties are copied into new MovieEntity object with watched and favourite set to false
    private func createScreenData(from moviesResponse: [Movie]) {
        var movies = [MovieEntity]()
        
        for movie in moviesResponse {
            if let movieRepresentable = MovieEntity.findByID(Int64(movie.id)) {
                movies.append(movieRepresentable)
            } else {
                movies.append(CoreDataHelper.createMovieEtitiy(from: movie))
            }
        }
        
        self.movies = movies
    }
}
