//
//  FavouritesViewModel.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 05.12.2020..
//

import Foundation
import Combine

class FavouritesViewModel {
    var favouritedMovies = CurrentValueSubject<[MovieRepresentable], Never>([])
    
    func fetchFavouritedMovies() {
        self.fetchData()
    }
    
    func updateFavourite(ofId id: Int) {
        var indexOfMovie: Int?
        
        for (index, movie) in favouritedMovies.value.enumerated() {
            if movie.id == id {
                indexOfMovie = index
            }
        }
        
        guard let indexToUpdate = indexOfMovie else { return }
        let newState = !favouritedMovies.value[indexToUpdate].favourite
        favouritedMovies.value[indexToUpdate].favourite = newState
        
        CoreDataHelper.updateFavourite(withId: id, newState)
        
    }
    
}

extension FavouritesViewModel {
    private func fetchData() {
        favouritedMovies.value = CoreDataHelper.fetchFavouriteMovies()
    }
}
