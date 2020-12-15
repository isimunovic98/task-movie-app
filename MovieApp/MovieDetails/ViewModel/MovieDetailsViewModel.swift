//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 06.12.2020..
//

import Foundation
import Combine

class MovieDetailsViewModel {
    var id: Int
    var movieRepresentable: MovieRepresentable!
    var screenData: [RowItem] = []
    
    let shouldShowBlurLoaderSubject = PassthroughSubject<Bool, Never>()
    let screenDataReadySubject = PassthroughSubject<Void, Never>()
    let dataLoaderSubject = PassthroughSubject<Bool, Never>()
    let actionButtonTappedSubject = PassthroughSubject<ActionButton, Never>()
    
    init(movieId: Int) {
        self.id = movieId
    }
    
    func fetchItems(dataLoader: PassthroughSubject<Bool, Never>) -> AnyCancellable {
        return dataLoader
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.global(qos: .background))
            .flatMap { [unowned self] value -> AnyPublisher<MovieDetails, Error> in
                self.shouldShowBlurLoaderSubject.send(true)
                return APIService.fetchItems(from: Constants.MovieDetails.response + String(id) + Constants.MovieDetails.apiKey, as: MovieDetails.self)
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .map{ [unowned self] movieDetails in
                self.createScreenData(from: movieDetails)
            }
            .sink(receiveCompletion: { _ in
                //Error handling
            }, receiveValue: { [unowned self] screenData in
                self.screenData = screenData
                self.screenDataReadySubject.send()
                self.shouldShowBlurLoaderSubject.send(false)
            })
    }
    
    func attachButtonClickListener(listener: PassthroughSubject<ActionButton, Never>) -> AnyCancellable {
        return listener
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .map({ [unowned self] button in
                self.updateStatus(in: screenData, onTapped: button)
            })
            .sink(receiveValue: { [unowned self] _ in
                self.dataLoaderSubject.send(false)
            })
    }
    
    
}

extension MovieDetailsViewModel {
    func updateStatus(in movies: [RowItem], onTapped button: ActionButton) {
        switch button.type {
        case .watched:
            if MovieEntity.findByID(id) == nil {
                CoreDataHelper.save(movieRepresentable, false, false)
            }
            CoreDataHelper.updateWatched(withId: id)
        case .favourited:
            if MovieEntity.findByID(id) == nil {
                CoreDataHelper.save(movieRepresentable, false, false)
            }
            CoreDataHelper.updateFavourited(withId: id)
        }
        //switchState(in: screenData)
    }
    
    private func createScreenData(from movieDetails: MovieDetails) -> [RowItem] {
        movieRepresentable = MovieRepresentable(movieDetails)
        var rowItems = [RowItem]()
        rowItems.append(createInfoItem(for: id, with: movieDetails.posterPath))
        rowItems.append(RowItem(content: movieDetails.title , type: .title))
        rowItems.append(RowItem(content: movieDetails.genres, type: .genres))
        rowItems.append(RowItem(content: movieDetails.tagline, type: .quote))
        rowItems.append(RowItem(content: movieDetails.overview , type: .overview))
        rowItems.append(RowItem(content: "dummy", type: .similarMovies))
        return rowItems
    }
    
    private func createInfoItem(for id: Int, with posterPath: String) -> RowItem {
        let dbMovie = MovieEntity.findByID(id)
        return RowItem(content: InfoItem(posterPath: posterPath, watched: dbMovie?.watched ?? false, favourited: dbMovie?.favourite ?? false) , type: .poster)
        
    }
    
//    private func switchState(in screenData: [RowItem]) {
//        let posterPath = movieRepresentable.posterPath
//        for index in 0..<screenData.count {
//            if screenData[index].type == .poster {
//                let newInfoItem = createInfoItem(for: id, with: posterPath)
//                self.screenData.append(RowItem(content: newInfoItem, type: .poster))
//            }
//        }
//    }
}
