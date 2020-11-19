//
//  NowPlayingViewPresenter.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 18.11.2020..
//

import UIKit

protocol NowPlayingPresenter: class {
    init(with view: NowPlayingViewController)
    func onViewDidLoad()
    func getMovies(showLoader: Bool)
}

class NowPlayingPresenterImpl: NowPlayingPresenter {
    
    private weak var view: NowPlayingViewController?
    
    required init(with view: NowPlayingViewController) {
        self.view = view
    }
    
    func onViewDidLoad() {
        getMovies(showLoader: true)
    }
    
    func getMovies(showLoader: Bool) {
        if showLoader {
            view?.startLoading()
        }
        
        APIService.fetch(from: Constants.ALL_MOVIES_URL, of: Movies.self) { (movies, message) in
            guard let movies = movies?.results else { return }
            self.view?.setMovies(movies)
        }
        
        if showLoader {
            view?.stopLoading()
        }
    }
}
