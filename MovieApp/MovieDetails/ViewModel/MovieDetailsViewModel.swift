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
    var screenData = CurrentValueSubject<[RowItem], Never>([])
    
    private var updateWatched: AnyPublisher<Void, Never> = PassthroughSubject<Void, Never>().eraseToAnyPublisher()
    private var subs = Set<AnyCancellable>()
    
    init(movieId: Int) {
        self.id = movieId
    }
    
    
    func attachViewEventListener(updateWatched: AnyPublisher<Void, Never>) {
        self.updateWatched = updateWatched
        
        updateWatched
            .sink(receiveValue: {
                self.changeWatchedButtonState()
            })
            .store(in: &subs)
    }
    
    func fetchMovieDetails() -> AnyCancellable {
        return APIService.fetchItems(from: MovieDetailsViewController.response + String(id) + MovieDetailsViewController.apiKey, for: MovieDetails.self)
            .map({
                self.createScreenData(from: $0)
            })
            .sink(receiveCompletion: { _ in
                //error handling
            }, receiveValue: { rowItems in
                self.screenData.value = rowItems
            })
    }
    
    
}

extension MovieDetailsViewModel {
    private func createScreenData(from movieDetails: MovieDetails) -> [RowItem] {
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
    
    private func changeWatchedButtonState() {
        for item in screenData.value {
            if let infoItem = item.content as? InfoItem {
                let newState = !infoItem.watched
                var newItem = infoItem
                newItem.watched = newState
                screenData.value[0].content = newItem
                CoreDataHelper.updateWatched(withId: id, newState)
            }
        }
    }
}
