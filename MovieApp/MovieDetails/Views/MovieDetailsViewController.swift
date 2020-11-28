//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 30/10/2020.
//

import UIKit
import SnapKit

class MovieDetailsViewController: UIViewController {
        
    //MARK: Properties
    var presenter: MovieDetailsPresenter
    
    let movieDetailsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "cellColor")
        tableView.allowsSelection = false
        return tableView
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "back"), for: .normal)
        return button
    }()
    
    let watchedButton: WatchedCustomButton = {
        let button = WatchedCustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let favouritesButton: FavouritesCustomButton = {
        let button = FavouritesCustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.makeMovieDetailsRepresentable()
    }
    
    //MARK: Init
    init(presenter: MovieDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI
extension MovieDetailsViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupUI() {
        addSubviews()
        setupConstraints()
        configureTableView()
        setupButtonActions()
    }
    
    fileprivate func setupConstraints() {
        
        movieDetailsTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.size.equalTo(40)
        }
        
        favouritesButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
            make.size.equalTo(45)
        }
        
        watchedButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(favouritesButton.snp.leading).offset(-15)
            make.size.equalTo(45)
        }
        
    }
}

//MARK: - Methods
extension MovieDetailsViewController {
    fileprivate func addSubviews() {
        view.addSubview(movieDetailsTableView)
        view.addSubview(backButton)
        view.addSubview(favouritesButton)
        view.addSubview(watchedButton)
    }
        
    fileprivate func setupButtonActions() {
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        watchedButton.addTarget(self, action: #selector(watchedButtonTapped), for: .touchUpInside)
        favouritesButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
    }
    
    //MARK: Actions
    @objc func watchedButtonTapped() {
        presenter.changeWatchedButtonState()
    }
    
    @objc func favouriteButtonTapped() {
        presenter.changeFavouriteButtonState()
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension MovieDetailsViewController: MovieDetailsDelegate {
    func setStatusOfButtons(for movieRepresenable: MovieRepresentable) {
        watchedButton.isSelected = movieRepresenable.watched
        favouritesButton.isSelected = movieRepresenable.favourite
    }

    func loading(_ shouldShowLoader: Bool){
        if shouldShowLoader {
            showBlurLoader()
        } else {
            removeBlurLoader()
        }
    }
    
    func reloadScreenData() {
        movieDetailsTableView.reloadData()
    }
}

//MARK: - TableViewDelegate
extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.rowItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemType = presenter.rowItems[indexPath.row].type
        
        switch itemType {
        
        case .poster:
            let cell: MoviePosterCell = tableView.dequeue(for: indexPath)
            
            let imageUrl = presenter.rowItems[indexPath.row].content
            cell.setMoviePoster(from: imageUrl as! String)
            
            return cell
            
        case .title:
            let cell: MovieTitleCell = tableView.dequeue(for: indexPath)
            
            let title = presenter.rowItems[indexPath.row].content
            cell.setMovieTitle(title: title as! String)
            
            return cell
            
        case .genres:
            let cell: MovieGenresCell = tableView.dequeue(for: indexPath)
            
            let genres = presenter.rowItems[indexPath.row].content
            cell.setMovieGenres(genres: genres as! [Genre])
            
            return cell
            
        case .quote:
            let cell: MovieQuoteCell = tableView.dequeue(for: indexPath)
            
            let quote = presenter.rowItems[indexPath.row].content
            cell.setMovieQuote(quote: quote as! String)
            
            return cell
            
        case .overview:
            let cell: MovieOverviewCell = tableView.dequeue(for: indexPath)
            
            let overview = presenter.rowItems[indexPath.row].content
            cell.setMovieOverview(overview: overview as! String)
            
            return cell
        }
    }
    
    func configureTableView() {
        setTableViewDelegates()
        
        movieDetailsTableView.register(MoviePosterCell.self, forCellReuseIdentifier: MoviePosterCell.reuseIdentifier)
        movieDetailsTableView.register(MovieTitleCell.self, forCellReuseIdentifier: MovieTitleCell.reuseIdentifier)
        movieDetailsTableView.register(MovieGenresCell.self, forCellReuseIdentifier: MovieGenresCell.reuseIdentifier)
        movieDetailsTableView.register(MovieQuoteCell.self, forCellReuseIdentifier: MovieQuoteCell.reuseIdentifier)
        movieDetailsTableView.register(MovieOverviewCell.self, forCellReuseIdentifier: MovieOverviewCell.reuseIdentifier)
    }
    
    func setTableViewDelegates() {
        movieDetailsTableView.delegate = self
        movieDetailsTableView.dataSource = self
    }
    
}
