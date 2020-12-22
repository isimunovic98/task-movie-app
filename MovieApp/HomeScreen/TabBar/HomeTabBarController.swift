//
//  ViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 21.12.2020..
//

import UIKit

class HomeTabBarController: UITabBarController {
    
    //MARK: Properties
    let nowPlayingVC: NowPlayingViewController = {
        let nowPlayingVM = NowPlayingViewModel()
        let viewController = NowPlayingViewController(viewModel: nowPlayingVM)
        viewController.tabBarItem.image = UIImage(named: "home")
        return viewController
    }()
    
    let watchedListVC: LabeledMoviesListViewController = {
        let watchedListVM = LabeledMoviesViewModel(type: .watched)
        let viewController = LabeledMoviesListViewController(viewModel: watchedListVM)
        viewController.tabBarItem.image = UIImage(named: "watched")
        return viewController
    }()
    
    let favouritesListVC: LabeledMoviesListViewController = {
        let favouritedVM = LabeledMoviesViewModel(type: .favourited)
        let viewController = LabeledMoviesListViewController(viewModel: favouritedVM)
        viewController.tabBarItem.image = UIImage(named: "favourite")
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [watchedListVC, nowPlayingVC, favouritesListVC]
        setupAppearance()
        navigationItem.backButtonTitle = ""
        UINavigationBar.appearance().tintColor = .white
    }

    func setupAppearance() {
        UITabBar.appearance().tintColor = .cyan
        UITabBar.setTransparentTabBar()
        
        self.selectedIndex = 1
    }
}


