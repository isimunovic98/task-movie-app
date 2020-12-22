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
    
    let actionButtonTappedSubject = PassthroughSubject<ActionButton, Never>()
    let screenDataReadySubject = PassthroughSubject<Void, Never>()
    let fetchScreenDataSubject = PassthroughSubject<Void, Never>()
    
    init(type: LabeledMoviesType) {
        self.type = type
    }
    
}

extension LabeledMoviesViewModel {
    func fetchScreenData(from subject: PassthroughSubject<Void, Never>) -> AnyCancellable{
        return subject.map { [unowned self] _ -> [MovieRepresentable] in
            switch type {
            case .watched:
                return CoreDataHelper.fetchWatchedMovies()
            case .favourited:
                return CoreDataHelper.fetchFavouritedMovies()
            }
        }
        .sink { [unowned self] screenData in
            self.screenData = screenData
            self.screenDataReadySubject.send()
        }
    }
    
    func attachActionButtonClickListener(listener: PassthroughSubject<ActionButton, Never>) -> AnyCancellable {
        return listener
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .map({ [unowned self] button -> [MovieRepresentable] in
                self.updateStatus(in: screenData, onTapped: button)
            })
            .sink(receiveValue: { [unowned self] newScreenData in
                self.screenData = newScreenData
                self.screenDataReadySubject.send()
            })
    }
}

private extension LabeledMoviesViewModel {
    func updateStatus(in screenData: [MovieRepresentable], onTapped button: ActionButton) -> [MovieRepresentable] {
        var indexOfMovie: Int?

        for (index, movie) in screenData.enumerated() {
            if movie.id == button.associatedMovieId {
                indexOfMovie = index
            }
        }

        guard let indexToUpdate = indexOfMovie else { return screenData }
        
        switch button.type {
        case .watched:
            return updateWatched(of: button.associatedMovieId, in: screenData, at: indexToUpdate)
        case .favourited:
            return updateFavourited(of: button.associatedMovieId, in: screenData, at: indexToUpdate)
        }
    }
    
    func updateFavourited(of id: Int?, in screenData: [MovieRepresentable], at index: Int) -> [MovieRepresentable] {
        guard let id = id else {
            return []
        }
        let newState = !screenData[index].favourited
        screenData[index].favourited = newState
        CoreDataHelper.updateFavourited(withId: id)
        return screenData
    }
    
    func updateWatched(of id: Int?, in screenData: [MovieRepresentable], at index: Int) -> [MovieRepresentable] {
        guard let id = id else {
            return []
        }
        let newState = !screenData[index].watched
        screenData[index].watched = newState
        CoreDataHelper.updateWatched(withId: id)
        return screenData
    }
}
