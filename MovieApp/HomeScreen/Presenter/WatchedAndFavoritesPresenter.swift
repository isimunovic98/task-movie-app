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
    
    var movies: [MovieEntity] = []
    
    var delegate: WatchedAndFavouritesDelegate!
    
    init(ofType presenterType: PresenterType) {
        self.presenterType = presenterType
    }
    
    func getMovies() {
        if presenterType == .watched {
            self.movies = CoreDataHelper.fetchWatchedMovies()
        } else {
            self.movies = CoreDataHelper.fetchFavouriteMovies()
        }
    }
    
}
