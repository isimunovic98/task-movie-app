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
    func setStatusOfButton(type: ButtonType, isSelected: Bool)
}

class MovieDetailsPresenter {
    
    
    var delegate: MovieDetailsDelegate!
    
    var watched = false
    var favourite = false
    var movieDetails: MovieDetails?
    var rowItems = [RowItem<Any, MovieDetailsCellTypes>]()

    
    func getRowItemsOfMovie(with id: Int) {
        delegate.loading(true)
        APIService.fetch(from: Constants.MovieDetails.response + String(id) + Constants.MovieDetails.apiKey, of: MovieDetails.self) { (movieDetails, message) in
            guard let _movieDetails = movieDetails else { return }
            self.movieDetails = _movieDetails
            self.setButtonStates(movieDetails!.id)
            self.createScreenData(from: _movieDetails)
            self.delegate.reloadScreenData()
            self.delegate.loading(false)
        }
    }
    
    func createScreenData(from movieDetails: MovieDetails) {
        rowItems.append(RowItem(content: movieDetails.poster_path , type: .poster))
        rowItems.append(RowItem(content: movieDetails.title , type: .title))
        rowItems.append(RowItem(content: movieDetails.genres , type: .genres))
        rowItems.append(RowItem(content: movieDetails.tagline , type: .quote))
        rowItems.append(RowItem(content: movieDetails.overview , type: .overview))
    }
    
    func changeWatchedButtonState() {
        watched = !watched
        delegate.setStatusOfButton(type: .watch, isSelected: watched)
        CoreDataHelper.saveOrUpdate(movieDetails!, watched, favourite)
    }
    
    func changeFavouriteButtonState() {
        favourite = !favourite
        delegate.setStatusOfButton(type: .favourite, isSelected: favourite)
        CoreDataHelper.saveOrUpdate(movieDetails!, watched, favourite)
    }
    
    func setButtonStates(_ id: Int) {
        if let appMovie = MovieEntity.findByID( Int64(id) ) {
            watched = appMovie.watched
            favourite = appMovie.favourite
            delegate.setStatusOfButton(type: .watch, isSelected: watched)
            delegate.setStatusOfButton(type: .favourite, isSelected: favourite)
        }
    }
}
