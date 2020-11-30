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
    
    func updateButton(ofType type: ButtonType, ofId id: Int) {
        var indexOfMovie: Int?
        
        for (index, movie) in moviesRepresentable.enumerated() {
            if movie.id == id {
                indexOfMovie = index
            }
        }
        
        guard let indexToUpdate = indexOfMovie else { return }
        if type == .watch {
            updateWatched(at: indexToUpdate, of: id)
        } else {
            updateFavourite(at: indexToUpdate, of: id)
        }
    }
    private func updateFavourite(at index: Int, of id: Int) {
        let newState = !moviesRepresentable[index].favourite
        moviesRepresentable[index].favourite = newState
    
        CoreDataHelper.updateFavourite(withId: id, newState)
    
        delegate.reloadScreenData()
    }
    
    private func updateWatched(at index: Int, of id: Int) {
        let newState = !moviesRepresentable[index].watched
        moviesRepresentable[index].watched = newState
    
        CoreDataHelper.updateWatched(withId: id, newState)
    
        delegate.reloadScreenData()
    }

}
