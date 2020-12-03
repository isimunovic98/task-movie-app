//
//  NowPlayingViewModel.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 03.12.2020..
//

import Foundation
import Combine

class NowPlayingViewModel {
    let reload = PassthroughSubject<Void, Never>()
    
    var movies: [MovieRepresentable] = []
    
    func fetchItems() -> AnyCancellable {
        return APIService.fetchItems(from: Constants.ALL_MOVIES_URL)
            .map{ movies in
                movies.map{
                    self.combineWithDB($0)
                }
            }
            .sink(receiveCompletion: { _ in
                self.reload.send()
            }, receiveValue: {
                self.movies = $0
            })
    }
    
    private func combineWithDB(_ movie: Movie) -> MovieRepresentable {
        let movieRepresentable = MovieRepresentable(movie)
        if let dbMovie = MovieEntity.findByID(movie.id) {
            movieRepresentable.watched = dbMovie.watched
            movieRepresentable.favourite = dbMovie.favourite
        }
        
        return movieRepresentable
    }
}
