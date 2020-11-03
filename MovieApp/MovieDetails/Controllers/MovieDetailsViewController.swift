//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 30/10/2020.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    static var response: String = "https://api.themoviedb.org/3/movie/"
    static var apiKey: String = "?api_key=aaf38b3909a4f117db3fb67e13ac6ef7&language=en-US"
        
    //MARK: Properties
    var id: Int
    var movieDetails: MovieDetails?
    var rowItems = [RowItem<Any, Any>]()
    
    let movieDetailsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "cellColor")
        tableView.allowsSelection = false
        return tableView
    }()
    
    let blurLoader: BlurLoader = {
        let view = BlurLoader()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        return button
    }()
    
    let watchedButtonView: WatchedButton = {
        let view = WatchedButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let favouritesButtonView: FavouritesButton = {
        let view = FavouritesButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    func createScreenData(fromDetails details: MovieDetails) {
        rowItems.append(RowItem(content: details.poster_path , type: MovieDetailsCellTypes.poster))
        rowItems.append(RowItem(content: details.title , type: MovieDetailsCellTypes.title))
        rowItems.append(RowItem(content: details.genres , type: MovieDetailsCellTypes.genres))
        rowItems.append(RowItem(content: details.tagline , type: MovieDetailsCellTypes.quote))
        rowItems.append(RowItem(content: details.overview , type: MovieDetailsCellTypes.overview))
    }
    
    //MARK: Actions
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: UI
extension MovieDetailsViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupUI() {
        view.addSubview(movieDetailsTableView)
        view.addSubview(backButton)
        view.addSubview(favouritesButtonView)
        view.addSubview(watchedButtonView)
        
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        setupConstraints()
        configureTableView()
    }
    
    fileprivate func setupConstraints() {
        let constraints = [
            movieDetailsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieDetailsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieDetailsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieDetailsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            
            favouritesButtonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favouritesButtonView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            favouritesButtonView.heightAnchor.constraint(equalToConstant: 45),
            favouritesButtonView.widthAnchor.constraint(equalToConstant: 45),
            
            watchedButtonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            watchedButtonView.trailingAnchor.constraint(equalTo: favouritesButtonView.leadingAnchor, constant: -15),
            watchedButtonView.heightAnchor.constraint(equalToConstant: 45),
            watchedButtonView.widthAnchor.constraint(equalToConstant: 45)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

//MARK: TableViewDelegate
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

        fetchData {
            DispatchQueue.main.async {
                self.createScreenData(fromDetails: self.movieDetails!)
                self.movieDetailsTableView.reloadData()
                self.view.removeBlurLoader(blurLoader: self.blurLoader)
            }
        }
    }
    
    func setTableViewDelegates() {
        movieDetailsTableView.delegate = self
        movieDetailsTableView.dataSource = self
    }
    
    
}

//MARK: JSON Decoder
extension MovieDetailsViewController {
    func fetchData(completion: @escaping ()->()) {
        let url = URL(string: MovieDetailsViewController.response + String(self.id) + MovieDetailsViewController.apiKey)
        
        guard url != nil else {
            self.presentNilURLAlert()
            return
        }
        view.showBlurLoader(blurLoader: blurLoader)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                
                do {
                    let details = try decoder.decode(MovieDetails.self, from: data!)
                    self.movieDetails = details
                    completion()
                    
                } catch {
                    self.presentJSONErrorAlert()
                }
            }
        }
        dataTask.resume()
    }
}
