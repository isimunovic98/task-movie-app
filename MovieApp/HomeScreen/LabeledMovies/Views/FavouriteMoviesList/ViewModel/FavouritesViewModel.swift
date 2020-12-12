//
//  FavouritesViewModel.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 05.12.2020..
//

import Foundation
import Combine

class FavouritesViewModel {
    var screenData: [MovieRepresentable] = []
    
    let screenDataReadySubject = PassthroughSubject<Void, Never>()
    let buttonTappedSubject = PassthroughSubject<Int, Never>()
    
    func fetchItems() {
        self.fetchFavouritedMovies()
        screenDataReadySubject.send()
    }
    
    func attachButtonTappedListener(listener: PassthroughSubject<Int, Never>) -> AnyCancellable {
        return listener
            .map({ [unowned self] id in
                self.updateFavourited(of: id, in: screenData)
            })
            .sink(receiveValue: { [unowned self] newScreenData in
                self.screenData = newScreenData
                self.screenDataReadySubject.send()
            })
    }
}

private extension FavouritesViewModel {
    func fetchFavouritedMovies() {
        screenData = CoreDataHelper.fetchFavouritedMovies()
    }
    
    func updateFavourited(of id: Int, in screenData: [MovieRepresentable]) -> [MovieRepresentable] {
        var indexOfMovie: Int?

        for (index, movie) in screenData.enumerated() {
            if movie.id == id {
                indexOfMovie = index
            }
        }

        guard let indexToUpdate = indexOfMovie else { return screenData }
        
        let newState = !screenData[indexToUpdate].favourited
        screenData[indexToUpdate].favourited = newState
        CoreDataHelper.updateFavourited(withId: id, newState)
        return screenData
    }
}
