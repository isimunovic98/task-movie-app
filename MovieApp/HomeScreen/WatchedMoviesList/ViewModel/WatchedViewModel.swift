//
//  WatchedViewModel.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 05.12.2020..
//

import Foundation
import Combine

class WatchedViewModel {
    var screenData: [MovieRepresentable] = []
    
    let screenDataReadySubject = PassthroughSubject<Void, Never>()
    let buttonTappedSubject = PassthroughSubject<Int, Never>()
    
    func fetchItems() {
        self.fetchWatchedMovies()
        screenDataReadySubject.send()
    }
    
    func attachButtonTappedListener(listener: PassthroughSubject<Int, Never>) -> AnyCancellable {
        return listener
            .map({ [unowned self] id in
                self.updateWatched(of: id, in: screenData)
            })
            .sink(receiveValue: { [unowned self] newScreenData in
                self.screenData = newScreenData
                self.screenDataReadySubject.send()
            })
    }
}

private extension WatchedViewModel {
    func fetchWatchedMovies() {
        screenData = CoreDataHelper.fetchWatchedMovies()
    }
    
    func updateWatched(of id: Int, in screenData: [MovieRepresentable]) -> [MovieRepresentable] {
        var indexOfMovie: Int?

        for (index, movie) in screenData.enumerated() {
            if movie.id == id {
                indexOfMovie = index
            }
        }

        guard let indexToUpdate = indexOfMovie else { return screenData }
        
        let newState = !screenData[indexToUpdate].watched
        screenData[indexToUpdate].watched = newState
        CoreDataHelper.updateWatched(withId: id, newState)
        return screenData
    }
}
