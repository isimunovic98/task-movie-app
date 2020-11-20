//
//  HomeScreenViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 20.11.2020..
//

import UIKit

class HomeScreenViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let nowPlayingPresenter = NowPlayingPresenter()
        let nowPlayingVC = NowPlayingViewController(presenter: nowPlayingPresenter)
        nowPlayingPresenter.delegate = nowPlayingVC
        nowPlayingVC.tabBarItem.image = UIImage(named: "home")
        
        let watchedPresenter = WatchedAndFavoritesPresenter(ofType: .watched)
        let watchedListVC = WatchedMoviesViewController(presenter: watchedPresenter)
        watchedPresenter.delegate = watchedListVC
        watchedListVC.tabBarItem.image = UIImage(named: "watched")
        
        let favouritesPresenter = WatchedAndFavoritesPresenter(ofType: .favourites)
        let favouriteListVC = FavouriteMoviesViewController(presenter: favouritesPresenter)
        favouritesPresenter.delegate = favouriteListVC
        favouriteListVC.tabBarItem.image = UIImage(named: "favourite")
        
        viewControllers = [nowPlayingVC, watchedListVC, favouriteListVC]
    }
    
}
