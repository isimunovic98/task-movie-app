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

    //MARK: Properties
    var id: Int
    
    var viewModel: MovieDetailsViewModel
    
    var subscriptions = Set<AnyCancellable>()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "cellColor")
        tableView.allowsSelection = false
        return tableView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.dataLoaderSubject.send(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController!.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.isTranslucent = true
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
    }
    
    fileprivate func addSubviews() {
        view.addSubview(tableView)
    }
    
    fileprivate func setupConstraints() {
        
        tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - Methods
extension MovieDetailsViewController {
    private func setupBindings() {
        viewModel.fetchItems(dataLoader: viewModel.dataLoaderSubject).store(in: &subscriptions)
        
        viewModel.screenDataReadySubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &subscriptions)
        
        viewModel.shouldShowBlurLoaderSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] showLoader in
                self?.showLoader(showLoader)
            })
            .store(in: &subscriptions)
        
        let buttonListener = viewModel.attachButtonClickListener(listener: viewModel.actionButtonTappedSubject)
        buttonListener.store(in: &subscriptions)
    }
    
    private func showLoader( _ shouldShowLoader: Bool) {
        if shouldShowLoader {
            showBlurLoader()
        } else {
            removeBlurLoader()
        }
    }
    
    private func processButtonTap(of button: ActionButton) {
        viewModel.actionButtonTappedSubject.send(button)
    }

}

//MARK: - TableViewDelegate
extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemType = viewModel.screenData[indexPath.row].type
        
        switch itemType {
        
        case .poster:
            let cell: MoviePosterCell = tableView.dequeue(for: indexPath)
            
            guard let item = viewModel.screenData[indexPath.row].content as? InfoItem else { return UITableViewCell() }
            
            cell.configure(with: item)
            
            cell.watchedButton.buttonTapped = { [weak self] button in
                self?.processButtonTap(of: button)
            }
            cell.favouritesButton.buttonTapped = { [weak self] button in
                self?.processButtonTap(of: button)
            }
            
            return cell
            
        case .title:
            let cell: MovieTitleCell = tableView.dequeue(for: indexPath)
            
            let title = viewModel.screenData[indexPath.row].content
            cell.setMovieTitle(title: title as! String)
            
            return cell
            
        case .genres:
            let cell: MovieGenresCell = tableView.dequeue(for: indexPath)
            
            let genres = viewModel.screenData[indexPath.row].content
            cell.setMovieGenres(genres: genres as! [Genre])
            
            return cell
            
        case .quote:
            let cell: MovieQuoteCell = tableView.dequeue(for: indexPath)
            
            let quote = viewModel.screenData[indexPath.row].content
            cell.setMovieQuote(quote: quote as! String)
            
            return cell
            
        case .overview:
            let cell: MovieOverviewCell = tableView.dequeue(for: indexPath)
            
            let overview = viewModel.screenData[indexPath.row].content
            cell.setMovieOverview(overview: overview as! String)
            
            return cell
            
        case .similarMovies:
            let cell: SimilarMoviesTableViewCell = tableView.dequeue(for: indexPath)
            
            let similarMovies = viewModel.screenData[indexPath.row].content
            cell.similarMovies = similarMovies as! [SimilarMovie]
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
        tableView.register(SimilarMoviesTableViewCell.self, forCellReuseIdentifier: SimilarMoviesTableViewCell.reuseIdentifier)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
}
