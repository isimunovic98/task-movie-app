//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 30/10/2020.
//

import UIKit
import SnapKit
import Combine

class MovieDetailsViewController: UIViewController {
    
    static var response: String = "https://api.themoviedb.org/3/movie/"
    static var apiKey: String = "?api_key=aaf38b3909a4f117db3fb67e13ac6ef7&language=en-US"
    
    //MARK: Properties
    var id: Int
    
    var viewModel: MovieDetailsViewModel
    
    var subscriptions = Set<AnyCancellable>()
    
    private var updateWatched = PassthroughSubject<Void,Never>()
    
    let tableView: UITableView = {
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
    
    //MARK: Init
    init(movieId id: Int) {
        self.id = id
        self.viewModel = MovieDetailsViewModel(movieId: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Lifecycle
extension MovieDetailsViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBindings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        
        tableView.snp.makeConstraints { (make) in
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
    private func setupBindings() {
        viewModel.attachViewEventListener(updateWatched: updateWatched.eraseToAnyPublisher())
        
        viewModel.fetchMovieDetails().store(in: &subscriptions)
        
        viewModel.screenData
            .sink(receiveValue: { _ in
                self.tableView.reloadData()
            })
            .store(in: &subscriptions)
    }
    
    fileprivate func addSubviews() {
        view.addSubview(tableView)
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
        updateWatched.send()
    }
    
    @objc func favouriteButtonTapped() {

    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableViewDelegate
extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.screenData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemType = viewModel.screenData.value[indexPath.row].type
        
        switch itemType {
        
        case .poster:
            let cell: MoviePosterCell = tableView.dequeue(for: indexPath)
            
            if let infoItem = viewModel.screenData.value[indexPath.row].content as? InfoItem {
                let imageUrl = infoItem.posterPath
                cell.setMoviePoster(from: imageUrl)
                watchedButton.isSelected = infoItem.watched
                favouritesButton.isSelected = infoItem.favourited
            }
            return cell
            
        case .title:
            let cell: MovieTitleCell = tableView.dequeue(for: indexPath)
            
            let title = viewModel.screenData.value[indexPath.row].content
            cell.setMovieTitle(title: title as! String)
            
            return cell
            
        case .genres:
            let cell: MovieGenresCell = tableView.dequeue(for: indexPath)
            
            let genres = viewModel.screenData.value[indexPath.row].content
            cell.setMovieGenres(genres: genres as! [Genre])
            
            return cell
            
        case .quote:
            let cell: MovieQuoteCell = tableView.dequeue(for: indexPath)
            
            let quote = viewModel.screenData.value[indexPath.row].content
            cell.setMovieQuote(quote: quote as! String)
            
            return cell
            
        case .overview:
            let cell: MovieOverviewCell = tableView.dequeue(for: indexPath)
            
            let overview = viewModel.screenData.value[indexPath.row].content
            cell.setMovieOverview(overview: overview as! String)
            
            return cell
        }
    }
    
    func configureTableView() {
        setTableViewDelegates()
        
        tableView.register(MoviePosterCell.self, forCellReuseIdentifier: MoviePosterCell.reuseIdentifier)
        tableView.register(MovieTitleCell.self, forCellReuseIdentifier: MovieTitleCell.reuseIdentifier)
        tableView.register(MovieGenresCell.self, forCellReuseIdentifier: MovieGenresCell.reuseIdentifier)
        tableView.register(MovieQuoteCell.self, forCellReuseIdentifier: MovieQuoteCell.reuseIdentifier)
        tableView.register(MovieOverviewCell.self, forCellReuseIdentifier: MovieOverviewCell.reuseIdentifier)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
}
