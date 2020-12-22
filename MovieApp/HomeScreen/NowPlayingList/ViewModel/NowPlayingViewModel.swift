//
//  NowPlayingViewModel.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 03.12.2020..
//

import Foundation
import Combine

class NowPlayingViewModel {
    var screenData: [MovieRepresentable] = []
    
    let actionButtonTappedSubject = PassthroughSubject<ActionButton, Never>()
    
    let screenDataReadySubject = PassthroughSubject<ReloadAction, Never>()
    let dataLoaderSubject = CurrentValueSubject<Bool, Never>(true)
    let shouldShowBlurLoaderSubject = PassthroughSubject<Bool, Never>()
    let errorHandlerSubject = PassthroughSubject<Error, Never>()
    
    func fetchItems(with dataLoader: CurrentValueSubject<Bool, Never>) -> AnyCancellable {
       return dataLoader
        .subscribe(on: DispatchQueue.global(qos: .background))
        .receive(on: DispatchQueue.global(qos: .background))
        .flatMap { [unowned self] value -> AnyPublisher<Movies, Error> in
            self.shouldShowBlurLoaderSubject.send(true)
            
            return APIService.fetchItems(from: Constants.ALL_MOVIES_URL, as: Movies.self)
        }
        .subscribe(on: DispatchQueue.global(qos: .background))
        .receive(on: RunLoop.main)
            .map{ [unowned self] movies in
                movies.results.map{
                    self.createScreenData(from: $0)
                }
            }
            .sink(receiveCompletion: { [unowned self] completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.errorHandlerSubject.send(error)
                }
            }, receiveValue: { [unowned self] moviesRepresentable in
                self.screenData = moviesRepresentable
                self.screenDataReadySubject.send(.reloadAll)
                self.shouldShowBlurLoaderSubject.send(false)
            })
    }
    func attachActionButtonClickListener(listener: PassthroughSubject<ActionButton, Never>) -> AnyCancellable {
        return listener
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .map({ [unowned self] button -> [MovieRepresentable] in
                self.updateStatus(in: screenData, onTapped: button)
            })
            .sink(receiveValue: {
                self.screenData = $0
            })
    }
}

//MARK: - Private Methods
private extension NowPlayingViewModel {
    func updateStatus(in screenData: [MovieRepresentable], onTapped button: ActionButton) -> [MovieRepresentable] {
        switch button.type {
        case .watched:
            return updateWatched(of: button.associatedMovieId!, in: screenData)
        case .favourited:
            return updateFavourited(of: button.associatedMovieId!, in: screenData)
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
