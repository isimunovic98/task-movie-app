//
//  MovieDetailsPresenter.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 19.11.2020..
//

import Foundation

protocol MovieDetailsPresenter: class {
    func getRowItemsOfMovie(with id: Int)
    func createScreenData(from movieDetails: MovieDetails)
    func changeWatchedButtonState()
    func changeFavouriteButtonState()
    func setButtonStates(_ id: Int) 
}

class MovieDetailsPresenterImpl: MovieDetailsPresenter {
    
    
    private weak var view: MovieDetailsViewController?
    
    var watched = false
    var favourite = false
    var movieDetails: MovieDetails?
    var rowItems = [RowItem<Any, MovieDetailsCellTypes>]()
    
    
    init(with view: MovieDetailsViewController) {
        self.view = view
    }
    
    func getRowItemsOfMovie(with id: Int) {
        view?.startLoading()
        APIService.fetch(from: Constants.MovieDetails.response + String(id) + Constants.MovieDetails.apiKey, of: MovieDetails.self) { (movieDetails, message) in
            guard let _movieDetails = movieDetails else { return }
            self.movieDetails = _movieDetails
            self.setButtonStates(movieDetails!.id)
            self.createScreenData(from: _movieDetails)
            self.view?.setRowItems(self.rowItems)
            self.view?.stopLoading()
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
        view?.watchedButton.isSelected = watched
        CoreDataHelper.saveOrUpdate(movieDetails!, watched, favourite)
    }
    
    func changeFavouriteButtonState() {
        favourite = !favourite
        view?.favouritesButton.isSelected = favourite
        CoreDataHelper.saveOrUpdate(movieDetails!, watched, favourite)
    }
    
    func setButtonStates(_ id: Int) {
        if let appMovie = MovieEntity.findByID( Int64(id) ) {
            watched = appMovie.watched
            favourite = appMovie.favourite
            view?.watchedButton.isSelected = watched
            view?.favouritesButton.isSelected = favourite
        }
    }
}
