//
//  MovieDetailsPresenter.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 19.11.2020..
//

import Foundation

protocol MovieDetailsDelegate: class {
    func reloadScreenData()
    func loading(_ shouldShowLoader: Bool)
    func presentJsonError(_ message: String)
}

class MovieDetailsPresenter {
    var delegate: MovieDetailsDelegate!
    
    var id: Int
    var rowItems: [RowItem] = []
    
    init(_ id: Int) {
        self.id = id
    }
    
    func makeMovieDetailsRepresentable() {
        delegate.loading(true)
        APIService.fetch(from: Constants.MovieDetails.response + String(id) + Constants.MovieDetails.apiKey, of: MovieDetails.self) { (movieDetails, message) in
            guard let movieDetails = movieDetails else {
                self.delegate.presentJsonError(message)
                return
            }
            self.rowItems = self.createScreenData(from: movieDetails)
            self.delegate.loading(false)
            self.delegate.reloadScreenData()
        }
    }
    
    func createScreenData(from movieDetails: MovieDetails) -> [RowItem] {
        var rowItems = [RowItem]()
        rowItems.append(createInfoItem(for: id, with: movieDetails.posterPath))
        rowItems.append(RowItem(content: movieDetails.title , type: .title))
        rowItems.append(RowItem(content: movieDetails.genres, type: .genres))
        rowItems.append(RowItem(content: movieDetails.tagline, type: .quote))
        rowItems.append(RowItem(content: movieDetails.overview , type: .overview))

        return rowItems
    }
    
    func createInfoItem(for id: Int, with posterPath: String) -> RowItem {
        let dbMoview = MovieEntity.findByID(id)
        return RowItem(content: InfoItem(posterPath: posterPath, watched: dbMoview?.watched ?? false, favourited: dbMoview?.favourite ?? false) , type: .poster)
        
    }

    func changeWatchedButtonState() {
        for item in rowItems {
            if let infoItem = item.content as? InfoItem {
                let newState = !infoItem.watched
                CoreDataHelper.updateWatched(withId: id, newState)
            }
        }
        makeMovieDetailsRepresentable()
    }
    
    func changeFavouriteButtonState() {
        for item in rowItems {
            if let infoItem = item.content as? InfoItem {
                let newState = !infoItem.favourited
                CoreDataHelper.updateFavourite(withId: id, newState)
                delegate.reloadScreenData()
            }
        }
        makeMovieDetailsRepresentable()
    }
}
