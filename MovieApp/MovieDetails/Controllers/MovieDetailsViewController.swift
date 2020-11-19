//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 30/10/2020.
//

import UIKit
import SnapKit

class MovieDetailsViewController: UIViewController {
    
    static var response: String = "https://api.themoviedb.org/3/movie/"
    static var apiKey: String = "?api_key=aaf38b3909a4f117db3fb67e13ac6ef7&language=en-US"
    
    //MARK: Properties
    var id: Int
    var watched = false
    var favourite = false
    var movieDetails: MovieDetails?
    var rowItems = [RowItem<Any, MovieDetailsCellTypes>]()
    let service = APIService()
    
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
    }
    
    //MARK: Init
    init(movieId id: Int) {
        self.id = id
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
        populateTableView()
        setupButtonActions()
        setButtonStates()
    }
    
    fileprivate func setupConstraints() {
        
        movieDetailsTableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
    
    fileprivate func populateTableView() {
        showBlurLoader()
        APIService.fetch(from: MovieDetailsViewController.response + String(self.id) + MovieDetailsViewController.apiKey, of: MovieDetails.self) { (movieDetails, message) in
            guard let _movieDetails = movieDetails else { return }
            self.movieDetails = _movieDetails
            self.createScreenData(from: _movieDetails)
            self.movieDetailsTableView.reloadData()
            self.removeBlurLoader()
        }
    }
    
    func createScreenData(from details: MovieDetails) {
        rowItems.append(RowItem(content: details.poster_path , type: .poster))
        rowItems.append(RowItem(content: details.title , type: .title))
        rowItems.append(RowItem(content: details.genres , type: .genres))
        rowItems.append(RowItem(content: details.tagline , type: .quote))
        rowItems.append(RowItem(content: details.overview , type: .overview))
    }
    
    fileprivate func setupButtonActions() {
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        watchedButton.addTarget(self, action: #selector(watchedButtonTapped), for: .touchUpInside)
        favouritesButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
    }
    
    func setButtonStates() {
        if let appMovie = MovieEntity.findByID( Int64(id) ) {
            watched = appMovie.watched
            favourite = appMovie.favourite
            watchedButton.isSelected = watched
            favouritesButton.isSelected = favourite
        }
    }
    
    //MARK: Actions
    @objc func watchedButtonTapped() {
        watched = !watched
        watchedButton.isSelected = watched
        CoreDataHelper.saveOrUpdate(movieDetails!, watched, favourite)
        
    }
    
    @objc func favouriteButtonTapped() {
        favourite = !favourite
        favouritesButton.isSelected = favourite
        CoreDataHelper.saveOrUpdate(movieDetails!, watched, favourite)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableViewDelegate
extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemType = rowItems[indexPath.row].type
        
        switch itemType {
        
        case .poster:
            let cell: MoviePosterCell = tableView.dequeue(for: indexPath)
            
            let imageUrl = rowItems[indexPath.row].content
            cell.setMoviePoster(from: imageUrl as! String)
            
            return cell
            
        case .title:
            let cell: MovieTitleCell = tableView.dequeue(for: indexPath)
            
            let title = rowItems[indexPath.row].content
            cell.setMovieTitle(title: title as! String)
            
            return cell
            
        case .genres:
            let cell: MovieGenresCell = tableView.dequeue(for: indexPath)
            
            let genres = rowItems[indexPath.row].content
            cell.setMovieGenres(genres: genres as! [Genre])
            
            return cell
            
        case .quote:
            let cell: MovieQuoteCell = tableView.dequeue(for: indexPath)
            
            let quote = rowItems[indexPath.row].content
            cell.setMovieQuote(quote: quote as! String)
            
            return cell
            
        case .overview:
            let cell: MovieOverviewCell = tableView.dequeue(for: indexPath)
            
            let overview = rowItems[indexPath.row].content
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
