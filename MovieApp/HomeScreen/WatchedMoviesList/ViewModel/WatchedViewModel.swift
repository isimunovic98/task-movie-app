//
//  WatchedViewModel.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 05.12.2020..
//

import Foundation
import Combine

class WatchedViewModel {
    var watchedMovies = CurrentValueSubject<[MovieRepresentable], Never>([])
    
    func fetchWatchedMovies() {
        self.fetchData()
    }
    
    func updateWatched(ofId id: Int) {
        var indexOfMovie: Int?
        
        for (index, movie) in watchedMovies.value.enumerated() {
            if movie.id == id {
                indexOfMovie = index
            }
        }
        
        guard let indexToUpdate = indexOfMovie else { return }
        let newState = !watchedMovies.value[indexToUpdate].watched
        watchedMovies.value[indexToUpdate].watched = newState
        
        CoreDataHelper.updateWatched(withId: id, newState)
        
    }
}

extension WatchedViewModel {
    private func fetchData() {
        watchedMovies.value = CoreDataHelper.fetchWatchedMovies()
    }
}
