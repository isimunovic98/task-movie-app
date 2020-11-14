//
//  NowPlayingListViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 30/10/2020.
//

import UIKit


class NowPlayingListViewController: UIViewController {
    
    //MARK: Properties
    let service = APIService(baseUrl: "")
    var movies = [Movie]()
    
    let nowPlayingTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        return tableView
    }()
    
    let blurLoader: BlurLoader = {
        let view = BlurLoader()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: "loading...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        control.tintColor = .white
        return control
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        service.getAllMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nowPlayingTableView.reloadData()
    }
}

//MARK: - UI
extension NowPlayingListViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupUI() {
        setupApperance()
        addSubviews()
        setupConstraints()
        configureTableView()
        configureRefreshControl()
        fetchData(showLoader: true)
    }
    
    fileprivate func setupApperance() {
        view.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    fileprivate func addSubviews() {
        view.addSubview(nowPlayingTableView)
        view.addSubview(blurLoader)
    }
    
    fileprivate func setupConstraints() {
        nowPlayingTableView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
    }
}

//MARK: - Methods
extension NowPlayingListViewController {
    fileprivate func configureRefreshControl() {
        nowPlayingTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        fetchData(showLoader: false)
    }
    
    func fetchData(showLoader: Bool) {
        if showLoader {
            view.showBlurLoader(blurLoader: blurLoader)
        }
        
        service.getAllMovies()
        service.completionHandler { [weak self] (movies, status, message) in
            if status {
                guard let self = self else { return }
                guard let _movies = movies else { return }
                self.movies = _movies.results
                self.nowPlayingTableView.reloadData()
                self.view.removeBlurLoader(blurLoader: self.blurLoader)
                self.refreshControl.endRefreshing()
            }
        }
    }
}


//MARK: - TableViewDelegate
extension NowPlayingListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NowPlayingCell = tableView.dequeue(for: indexPath)
        
        let movie = movies[indexPath.section]
        cell.configure(withMovie: movie)
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
        let id = movies[indexPath.section].id
        
        let movieDetailsController = MovieDetailsViewController(movieId: id)
        
        navigationController?.pushViewController(movieDetailsController, animated: false)
    }
    
    func configureTableView() {
        setTableViewDelegates()
        
        nowPlayingTableView.register(NowPlayingCell.self, forCellReuseIdentifier: NowPlayingCell.reuseIdentifier)
    }
    
    func setTableViewDelegates() {
        nowPlayingTableView.delegate = self
        nowPlayingTableView.dataSource = self
    }
}
