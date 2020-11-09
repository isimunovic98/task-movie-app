//
//  FavouriteListViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 09/11/2020.
//
import UIKit

class FavouriteListViewController: UIViewController, ReusableView {
    
    //MARK: Properties
    let coreDataHelper = CoreDataHelper()
    
    var movies = [MovieAppMovie]()
    
    let watchedMoviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
}

//MARK: - UI
extension FavouriteListViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        addSubviews()
        setupConstraints()
        configureTableView()
        fetchData()
    }
    
    fileprivate func addSubviews() {
        view.addSubview(watchedMoviesTableView)
    }
    
    fileprivate func setupConstraints() {
        let constraints = [
            watchedMoviesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            watchedMoviesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            watchedMoviesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            watchedMoviesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

//MARK: - TableViewDelegate
extension FavouriteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WatchedFavouriteCell = tableView.dequeue(for: indexPath)
        
        let movie = movies[indexPath.section]
        
        cell.configure(withMovie: movie, forType: FavouriteListViewController.reuseIdentifier)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.CELL_SPACING
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "backgroundColor")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = Int(movies[indexPath.section].id)
        
        let movieDetailsController = MovieDetailsViewController(movieId: id)
        
        navigationController?.pushViewController(movieDetailsController, animated: false)
    }
    
    func configureTableView() {
        setTableViewDelegates()
        
        watchedMoviesTableView.register(WatchedFavouriteCell.self, forCellReuseIdentifier: WatchedFavouriteCell.reuseIdentifier)
    }
    
    func setTableViewDelegates() {
        watchedMoviesTableView.delegate = self
        watchedMoviesTableView.dataSource = self
    }
}

extension FavouriteListViewController {
    func fetchData() {
        self.movies = CoreDataHelper.fetchFavouriteMovies()
        
        watchedMoviesTableView.reloadData()
    }
}

