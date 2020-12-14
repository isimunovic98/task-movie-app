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
    let buttonTappedSubject = PassthroughSubject<Action, Never>()
    
    init(movieId: Int) {
        self.id = movieId
    }
    
    func fetchItems(dataLoader: PassthroughSubject<Bool, Never>) -> AnyCancellable {
        return dataLoader
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.global(qos: .background))
            .flatMap { [unowned self] value -> AnyPublisher<MovieDetails, Error> in
                self.shouldShowBlurLoaderSubject.send(true)
                return APIService.fetchItems(from: Constants.MovieDetails.response + String(id) + Constants.MovieDetails.apiKey, for: MovieDetails.self)
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
    
    func attachButtonClickListener(listener: PassthroughSubject<Action, Never>) -> AnyCancellable {
        return listener
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main) // MUST BE MAIN CUZ updateStatus(line 63) is called which uses find by id whuch uses appdelegate
            .map({ [unowned self] action in
                self.updateStatus(in: movieRepresentable, for: action)
            })
            .sink(receiveValue: { [unowned self] _ in
                self.dataLoaderSubject.send(false)
            })
    }
    
    
}
#warning("this is a but funky to me, maybe having 'watched' and 'fav' properties also? Maybe having function to change values in 'InfoItem' so i dont have to call dataLoaderSubject in line 49, instead have the function return new info item, tho that seems a lot of code then")
extension MovieDetailsViewModel {
    func updateStatus(in movies: MovieRepresentable, for action: Action) {
        switch action {
        case .watchedTapped(let id):
            if MovieEntity.findByID(id) == nil {
                CoreDataHelper.save(movieRepresentable, false, false)
            }
            CoreDataHelper.updateWatched(withId: id)
        case .favouritedTapped(let id):
            if MovieEntity.findByID(id) == nil {
                CoreDataHelper.save(movieRepresentable, false, false)
            }
            CoreDataHelper.updateFavourited(withId: id)
        }
    }
    
    private func createScreenData(from movieDetails: MovieDetails) -> [RowItem] {
        movieRepresentable = MovieRepresentable(movieDetails)
        var rowItems = [RowItem]()
        rowItems.append(createInfoItem(for: id, with: movieDetails.posterPath))
        rowItems.append(RowItem(content: movieDetails.title , type: .title))
        rowItems.append(RowItem(content: movieDetails.genres, type: .genres))
        rowItems.append(RowItem(content: movieDetails.tagline, type: .quote))
        rowItems.append(RowItem(content: movieDetails.overview , type: .overview))
        
        return rowItems
    }
    
    private func createInfoItem(for id: Int, with posterPath: String) -> RowItem {
        let dbMoview = MovieEntity.findByID(id)
        return RowItem(content: InfoItem(posterPath: posterPath, watched: dbMoview?.watched ?? false, favourited: dbMoview?.favourite ?? false) , type: .poster)
        
    }
}
