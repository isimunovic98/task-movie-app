//
//  WatchedListViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 05/11/2020.
//

import UIKit

class WatchedListViewController: UIViewController, ReusableView {
    
    //MARK: Properties
    var movies = [MovieEntity]()
    
    let watchedMoviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        return tableView
    }()

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
}

//MARK: - UI
extension WatchedListViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupUI() {
        setupAppearance()
        addSubviews()
        setupConstraints()
        configureTableView()
        fetchData()
    }
    
    fileprivate func setupAppearance() {
        view.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    fileprivate func addSubviews() {
        view.addSubview(watchedMoviesTableView)
    }
    
    fileprivate func setupConstraints() {
        watchedMoviesTableView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
    }
}

//MARK: - Methods
extension WatchedListViewController {
    func fetchData() {
        self.movies = CoreDataHelper.fetchWatchedMovies()
        
        watchedMoviesTableView.reloadData()
    }
}


//MARK: - TableViewDelegate
extension WatchedListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WatchedFavouriteCell = tableView.dequeue(for: indexPath)
        
        let movie = movies[indexPath.section]
        
        cell.configure(withMovie: movie, forType: WatchedListViewController.reuseIdentifier)
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
