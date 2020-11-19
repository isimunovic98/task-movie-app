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
protocol WatchedAndFavouritesPresenter: class {
    func onViewDidLoad()
    func onViewWillAppear()
    func getMovies()
}

class WatchedAndFavoritesPresenterImpl: WatchedAndFavouritesPresenter {
    
    private weak var view: WatchedAndFavouritesProtocol?
    private var presenterType: PresenterType?
    
    private var movies: [MovieEntity]?
    
    init(with view: WatchedAndFavouritesProtocol, ofType presenterType: PresenterType) {
        self.view = view
        self.presenterType = presenterType
    }
    
    func getMovies() {
        if presenterType == .watched {
            self.movies = CoreDataHelper.fetchWatchedMovies()
        } else {
            self.movies = CoreDataHelper.fetchFavouriteMovies()
        }
        guard let movies = movies else { return }
        view?.setMovies(movies)
    }
    
    func onViewDidLoad() {
        getMovies()
    }
    
    func onViewWillAppear() {
        getMovies()
    }
    
    
}
