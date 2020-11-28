//
//  WatchedAndFavoritesPresenter.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 19.11.2020..
//

import Foundation

enum PresenterType {
    case watched
    case favourites
}
protocol WatchedAndFavouritesDelegate: class {
    func reloadScreenData()
}

class WatchedAndFavoritesPresenter {
    
    private var presenterType: PresenterType
    
    var moviesRepresentable: [MovieRepresentable] = []
    
    var delegate: WatchedAndFavouritesDelegate!
    
    init(ofType presenterType: PresenterType) {
        self.presenterType = presenterType
    }
    
    func getMovies() {
        if presenterType == .watched {
            self.moviesRepresentable = CoreDataHelper.fetchWatchedMovies()
        } else {
            self.moviesRepresentable = CoreDataHelper.fetchFavouriteMovies()
        }
        delegate.reloadScreenData()
    }
    
    func updateFavourite(for movieRepresentable: MovieRepresentable) {
        for movie in moviesRepresentable {
            if movie.id == movieRepresentable.id {
                movie.favourite = !movie.favourite
            }
        }
    
        CoreDataHelper.updateFavourite(withId: movieRepresentable.id, movieRepresentable.favourite)
    
        delegate.reloadScreenData()
    }
    
    func updateWatched(for movieRepresentable: MovieRepresentable) {
        for movie in moviesRepresentable {
            if movie.id == movieRepresentable.id {
                movie.watched = !movie.watched
            }
        }
    
        CoreDataHelper.updateWatched(withId: movieRepresentable.id, movieRepresentable.watched)
    
        delegate.reloadScreenData()
    }

}
