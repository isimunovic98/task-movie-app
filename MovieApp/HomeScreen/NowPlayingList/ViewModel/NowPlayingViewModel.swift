//
//  NowPlayingViewModel.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 03.12.2020..
//

import Foundation
import Combine

//better naming
enum State {
    case reloadAll
    case reloadCell(Int)
}

class NowPlayingViewModel {
    var screenData: [MovieRepresentable] = []
    
    let screenDataReadySubject = PassthroughSubject<State, Never>()
    let dataLoaderSubject = CurrentValueSubject<Bool, Never>(true)
    let shouldShowBlurLoaderSubject = PassthroughSubject<Bool, Never>()
    let buttonTappedSubject = PassthroughSubject<Action, Never>()
    
    func fetchItems(with dataLoader: CurrentValueSubject<Bool, Never>) -> AnyCancellable {
       return dataLoader
            .flatMap { [unowned self] value -> AnyPublisher<Movies, Error> in
                self.shouldShowBlurLoaderSubject.send(true)
                return APIService.fetchItems(from: Constants.ALL_MOVIES_URL, for: Movies.self)
            }
            .map{ [unowned self] movies in
                movies.results.map{
                    self.createScreenData(from: $0)
                }
            }
            .sink(receiveCompletion: { _ in
                //Error handling
            }, receiveValue: { [unowned self] moviesRepresentable in
                self.screenData = moviesRepresentable
                self.screenDataReadySubject.send(.reloadAll)
                self.shouldShowBlurLoaderSubject.send(false)
            })
    }
    
    #warning("I would like to call screenDataReadySubject.send(.reloadCell(index)) in sink but I'm not sure whats the best way to get index")
    func attachButtonClickListener(listener: PassthroughSubject<Action, Never>) -> AnyCancellable {
        return listener
            .map({ [unowned self] action -> [MovieRepresentable] in
                self.updateStatus(in: screenData, for: action)
            })
            .sink(receiveValue: {
                self.screenData = $0
            })

    }
}

//MARK: - Private Methods
private extension NowPlayingViewModel {
    func updateStatus(in screenData: [MovieRepresentable], for action: Action) -> [MovieRepresentable] {
        switch action {
        case .watchedTapped(let id):
            return updateWatched(of: id, in: screenData)
        case .favouritedTapped(let id):
            return updateFavourited(of: id, in: screenData)
        }
    }
    
    func updateWatched(of id: Int, in screenData: [MovieRepresentable]) -> [MovieRepresentable] {
        for index in 0..<screenData.count {
            if screenData[index].id == id {
                let newState = !screenData[index].watched
                screenData[index].watched = newState
                CoreDataHelper.saveOrUpdate(screenData[index])
                screenDataReadySubject.send(.reloadCell(index))
                return screenData
            }
        }
        return screenData
    }
    
    func updateFavourited(of id: Int, in screenData: [MovieRepresentable]) -> [MovieRepresentable] {
        for index in 0..<screenData.count {
            if screenData[index].id == id {
                let newState = !screenData[index].favourited
                screenData[index].favourited = newState
                CoreDataHelper.saveOrUpdate(screenData[index])
                screenDataReadySubject.send(.reloadCell(index))
                return screenData
            }
        }
        return screenData
    }
    
    
    
    func createScreenData(from movie: Movie) -> MovieRepresentable {
        let movieRepresentable = MovieRepresentable(movie)
        if let dbMovie = MovieEntity.findByID(movie.id) {
            movieRepresentable.watched = dbMovie.watched
            movieRepresentable.favourited = dbMovie.favourite
        }
        
        return movieRepresentable
    }
}
