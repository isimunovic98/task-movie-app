//
//  FavouriteListViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 09/11/2020.
//
import UIKit

class FavouriteListViewController: UIViewController, ReusableView {
    
    //MARK: Properties
    var moviesRepresentable = [MovieRepresentable]()
    
    let favouriteMoviesTableView: UITableView = {
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
extension FavouriteListViewController {
    
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
        view.addSubview(favouriteMoviesTableView)
    }
    
    fileprivate func setupConstraints() {
        favouriteMoviesTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }
        
    }
}

//MARK: - Methods
extension FavouriteListViewController {
    func fetchData() {
        self.moviesRepresentable = CoreDataHelper.fetchFavouriteMovies()
        
        favouriteMoviesTableView.reloadData()
    }
}

//MARK: - TableViewDelegate
extension FavouriteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WatchedFavouriteCell = tableView.dequeue(for: indexPath)
        
        let movieRepresentable = moviesRepresentable[indexPath.section]
        
        cell.configure(withMovieRepresentable: movieRepresentable, forType: FavouriteListViewController.reuseIdentifier)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.moviesRepresentable.count
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
        let id = moviesRepresentable[indexPath.section].id
        
        let movieDetailsController = MovieDetailsViewController(movieId: id)
        
        navigationController?.pushViewController(movieDetailsController, animated: false)
    }
    
    func configureTableView() {
        setTableViewDelegates()
        
        favouriteMoviesTableView.register(WatchedFavouriteCell.self, forCellReuseIdentifier: WatchedFavouriteCell.reuseIdentifier)
    }
    
    func setTableViewDelegates() {
        favouriteMoviesTableView.delegate = self
        favouriteMoviesTableView.dataSource = self
    }
}
