//
//  NowPlayingListViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 30/10/2020.
//

import UIKit

class NowPlayingListViewController: UIViewController {
    
    //MARK: Static Properties
    static var url: String = "https://api.themoviedb.org/3/movie/now_playing?api_key=aaf38b3909a4f117db3fb67e13ac6ef7&language=en-US&page=1"
        
    //MARK: Properties
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
    }
}

extension NowPlayingListViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        view.addSubview(nowPlayingTableView)
        view.addSubview(blurLoader)
        
        configureTableView()
        setupConstraints()
        configureRefreshControl()
        fetchData(showLoader: true)
    }
    
    fileprivate func setupConstraints() {
        let constraints = [
            nowPlayingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nowPlayingTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            nowPlayingTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            nowPlayingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    fileprivate func configureRefreshControl() {
        nowPlayingTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        fetchData(showLoader: false)
    }
}


//MARK: TableViewDelegate
extension NowPlayingListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NowPlayingCell = tableView.dequeue(for: indexPath)
        
        let movie = movies[indexPath.section]
        cell.configure(withMovie: movie)
        return cell
    }
    
    //MARK: Sections
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
    
    //MARK: didSelectRowAt
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


extension NowPlayingListViewController {
    func fetchData(showLoader: Bool) {
        
        if showLoader {
            view.showBlurLoader(blurLoader: blurLoader)
        }
        let url = URL(string: NowPlayingListViewController.url)
        
        guard url != nil else {
            self.presentNilURLAlert()
            return
        }
        loadDataIntoTableView(from: url!)
    }
    
    func loadDataIntoTableView(from url: URL) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                
                do {
                    let movies = try decoder.decode(MovieResponse.self, from: data!)
                    self.movies = movies.results
                    DispatchQueue.main.async {
                        self.nowPlayingTableView.reloadData()
                        self.view.removeBlurLoader(blurLoader: self.blurLoader)
                        self.refreshControl.endRefreshing()
                    }
                    
                } catch {
                    self.presentJSONErrorAlert()
                }
            }
        }
        dataTask.resume()
    }
}
