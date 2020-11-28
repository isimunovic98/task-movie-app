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
    func setStatusOfButtons(for movieRepresentable: MovieRepresentable)
}

class MovieDetailsPresenter {
    var delegate: MovieDetailsDelegate!
    
    var id: Int
    var movieRepresentable: MovieRepresentable?
    var rowItems = [RowItem]()
    
    init(_ id: Int) {
        self.id = id
    }
    
    func makeMovieDetailsRepresentable() {
        delegate.loading(true)
        APIService.fetch(from: Constants.MovieDetails.response + String(id) + Constants.MovieDetails.apiKey, of: MovieDetails.self) { (movieDetails, message) in
            guard let movieDetails = movieDetails else { return }
            self.movieRepresentable = MovieRepresentable(movieDetails)
            self.createScreenData(from: self.movieRepresentable)
            self.delegate.loading(false)
        }
    }
    
    func createScreenData(from movieRepresentable: MovieRepresentable?) {
        guard let movieRepresentable = movieRepresentable else { return }
        rowItems.append(RowItem(content: movieRepresentable.posterPath , type: .poster))
        rowItems.append(RowItem(content: movieRepresentable.title , type: .title))
        rowItems.append(RowItem(content: movieRepresentable.genres!, type: .genres))
        rowItems.append(RowItem(content: movieRepresentable.tagline!, type: .quote))
        rowItems.append(RowItem(content: movieRepresentable.overview , type: .overview))
        
        if let movie = MovieEntity.findByID(id) {
            movieRepresentable.watched = movie.watched
            movieRepresentable.favourite = movie.favourite
        }
        
        delegate.setStatusOfButtons(for: movieRepresentable)
        delegate.reloadScreenData()
    }
    

    func changeWatchedButtonState() {
        if let movieRepresentable = movieRepresentable {
            movieRepresentable.watched = !movieRepresentable.watched
            delegate.setStatusOfButtons(for: movieRepresentable)
            CoreDataHelper.saveOrUpdate(movieRepresentable)
        }
    }
    
    func changeFavouriteButtonState() {
        if let movieRepresentable = movieRepresentable {
            movieRepresentable.favourite = !movieRepresentable.favourite
            delegate.setStatusOfButtons(for: movieRepresentable)
            CoreDataHelper.saveOrUpdate(movieRepresentable)
        }
    }
}
