//
//  LabeledMoviesViewModel.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 11.12.2020..
//

import Foundation
import Combine

enum LabeledMoviesType {
    case watched
    case favourited
}

class LabeledMoviesViewModel {
    var type: LabeledMoviesType
    var screenData: [MovieRepresentable] = []
    
    let screenDataReadySubject = PassthroughSubject<Void, Never>()
    let buttonTappedSubject = PassthroughSubject<Int, Never>()
    
    init(type: LabeledMoviesType) {
        self.type = type
    }
    
}

extension LabeledMoviesViewModel {
    func fetchScreenData() {
        switch type {
        case .watched:
            screenData = CoreDataHelper.fetchWatchedMovies()
        case .favourited:
            screenData = CoreDataHelper.fetchFavouritedMovies()
        }
        
        screenDataReadySubject.send()
    }
    
    func attachButtonTappedListener(listener: PassthroughSubject<Int, Never>) -> AnyCancellable {
        return listener
            .map({ [unowned self] id in
                self.updateStatus(of: id, in: screenData)
            })
            .sink(receiveValue: { [unowned self] newScreenData in
                self.screenData = newScreenData
                self.screenDataReadySubject.send()
            })
    }
}

private extension LabeledMoviesViewModel {
    func updateStatus(of id: Int, in screenData: [MovieRepresentable]) -> [MovieRepresentable] {
        var indexOfMovie: Int?

        for (index, movie) in screenData.enumerated() {
            if movie.id == id {
                indexOfMovie = index
            }
        }

        guard let indexToUpdate = indexOfMovie else { return screenData }
        
        switch type {
        case .watched:
            return updateWatched(of: id, in: screenData, at: indexToUpdate)
        case .favourited:
            return updateFavourited(of: id, in: screenData, at: indexToUpdate)
        }
    }
    
    func updateFavourited(of id: Int, in screenData: [MovieRepresentable], at index: Int) -> [MovieRepresentable] {
        let newState = !screenData[index].favourited
        screenData[index].favourited = newState
        CoreDataHelper.updateFavourited(withId: id, newState)
        return screenData
    }
    
    func updateWatched(of id: Int, in screenData: [MovieRepresentable], at index: Int) -> [MovieRepresentable] {
        let newState = !screenData[index].watched
        screenData[index].watched = newState
        CoreDataHelper.updateWatched(withId: id, newState)
        return screenData
    }
}
