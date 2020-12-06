//
//  NowPlayingViewModel.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 03.12.2020..
//

import Foundation
import Combine


class NowPlayingViewModel {
    var movies = CurrentValueSubject<[MovieRepresentable], Never>([])
    
    func fetchItems() -> AnyCancellable {
        return APIService.fetchItems(from: Constants.ALL_MOVIES_URL, for: Movies.self)
            .map{ movies in
                movies.results.map{
                    self.combineWithDB($0)
                }
            }
            .sink(receiveCompletion: { _ in
                //Error hadnling
            }, receiveValue: { [weak self] moviesRepresentable in
                self?.movies.value = moviesRepresentable
            })
    }
    
}

//MARK: - Public Methods
extension NowPlayingViewModel {
    func updateWatched(for id: Int) {
        
        for index in 0..<movies.value.count {
            if movies.value[index].id == id {
                let watched = movies.value[index].watched
                movies.value[index].watched = !watched
                CoreDataHelper.saveOrUpdate(movies.value[index])
            }
        }
        
    }
    
    func updateFavourite(for id: Int) {
        for index in 0..<movies.value.count {
            if movies.value[index].id == id {
                let fav = movies.value[index].favourite
                movies.value[index].favourite = !fav
                CoreDataHelper.saveOrUpdate(movies.value[index])
            }
        }
    }
}


//MARK: - Private Methods
extension NowPlayingViewModel {
    
    private func combineWithDB(_ movie: Movie) -> MovieRepresentable {
        var movieRepresentable = MovieRepresentable(movie)
        if let dbMovie = MovieEntity.findByID(movie.id) {
            movieRepresentable.watched = dbMovie.watched
            movieRepresentable.favourite = dbMovie.favourite
        }
        
        return movieRepresentable
    }
}
