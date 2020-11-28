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
    
    var moviesRepresentable: [MovieRepresentable] = []
    
    func getMovies(showLoader: Bool) {
        if showLoader {
            delegate.loading(true)
        }
        
        APIService.fetch(from: Constants.ALL_MOVIES_URL, of: Movies.self) { (movies, message) in
            guard let movies = movies?.results else {
                self.delegate.presentJsonError(message)
                return
            }
            self.createScreenData(from: movies)
            self.delegate.reloadScreenData()
        }
        
        if showLoader {
            delegate.loading(false)
        }
    }

    private func createScreenData(from movies: [Movie]) {
        var moviesTemp = [MovieRepresentable]()
        
        for movie in movies {
            if let movieEntity = MovieEntity.findByID(movie.id) {
                let movieRepresentable = MovieRepresentable(movieEntity)
                moviesTemp.append(movieRepresentable)
            } else {
                let movieRepresentable = MovieRepresentable(movie)
                moviesTemp.append(movieRepresentable)
            }
        }
        
        self.moviesRepresentable = moviesTemp
    }
    
    func watchedTapped(on movieRepresentable: MovieRepresentable) {
        for movie in moviesRepresentable {
            if movie.id == movieRepresentable.id {
                movie.watched = !movie.watched
            }
        }
        CoreDataHelper.saveOrUpdate(movieRepresentable)
        delegate.reloadScreenData()
    }
    
    func favouriteTapped(on movieRepresentable: MovieRepresentable) {
        for movie in moviesRepresentable {
            if movie.id == movieRepresentable.id {
                movie.favourite = !movie.favourite
            }
        }
        CoreDataHelper.saveOrUpdate(movieRepresentable)
        delegate.reloadScreenData()
    }
}
