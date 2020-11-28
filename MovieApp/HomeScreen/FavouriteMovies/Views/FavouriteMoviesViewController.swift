//
//  FavouriteListViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 09/11/2020.
//
import UIKit

class FavouriteMoviesViewController: UIViewController, ReusableView {
    
    //MARK: Properties
    var presenter: WatchedAndFavoritesPresenter
    
    let tableView: UITableView = {
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
        presenter.getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getMovies()
    }
    
    //MARK: Init
    init(presenter: WatchedAndFavoritesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI
extension FavouriteMoviesViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupUI() {
        setupAppearance()
        addSubviews()
        setupConstraints()
        configureTableView()
    }
    
    fileprivate func setupAppearance() {
        view.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    fileprivate func addSubviews() {
        view.addSubview(tableView)
    }
    
    fileprivate func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }
        
    }
}

extension FavouriteMoviesViewController: WatchedAndFavouritesDelegate {
    func reloadScreenData() {
        tableView.reloadData()
    }
}

extension FavouriteMoviesViewController: FavouriteCellDelegate {
    func onFavouriteButtonTapped(for movieRepresentable: MovieRepresentable) {
        presenter.updateFavourite(for: movieRepresentable)
    }
}



//MARK: - TableViewDelegate
extension FavouriteMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WatchedFavouriteCell = tableView.dequeue(for: indexPath)
        
        let movie = presenter.moviesRepresentable[indexPath.section]

        cell.favouritesDelegate = self
        cell.configure(withMovie: movie, ofType: FavouriteMoviesViewController.reuseIdentifier)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.moviesRepresentable.count
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
        let id = presenter.moviesRepresentable[indexPath.section].id
        
        let presenter = MovieDetailsPresenter(id)
        let movieDetailsController = MovieDetailsViewController(presenter: presenter)
        presenter.delegate = movieDetailsController
        
        navigationController?.pushViewController(movieDetailsController, animated: false)
    }
    
    func configureTableView() {
        setTableViewDelegates()
        
        tableView.register(WatchedFavouriteCell.self, forCellReuseIdentifier: WatchedFavouriteCell.reuseIdentifier)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
