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
}

class NowPlayingPresenter {
    
    var delegate: NowPlayingDelegate!
    
    var movies: [Movie] = []
    
    func getMovies(showLoader: Bool) {
        if showLoader {
            delegate.loading(true)
        }
        
        APIService.fetch(from: Constants.ALL_MOVIES_URL, of: Movies.self) { (movies, message) in
            guard let movies = movies?.results else { return }
            self.movies = movies
            self.delegate.reloadScreenData()
        }
        
        if showLoader {
            delegate.loading(false)
        }
    }
}
