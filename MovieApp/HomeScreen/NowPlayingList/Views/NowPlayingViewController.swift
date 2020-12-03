//
//  NowPlayingListViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 30/10/2020.
//

import UIKit
import Combine

class NowPlayingViewController: UIViewController {
        
    //MARK: Properties
    private var viewModel = NowPlayingViewModel()
    var sub: AnyCancellable?
    private var subscriptions = Set<AnyCancellable>()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        return collectionView
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
        setupBindings()
        sub = viewModel.fetchItems()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        fetchData(showLoader: true)
//    }
}

//MARK: - UI
extension NowPlayingViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupUI() {
        setupApperance()
        addSubviews()
        setupConstraints()
        configureCollectionView()
        configureRefreshControl()
        //fetchData(showLoader: true)
    }
    
    fileprivate func setupApperance() {
        view.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    fileprivate func addSubviews() {
        view.addSubview(collectionView)
    }
    
    fileprivate func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - Methods
extension NowPlayingViewController {
    private func setupBindings() {
        viewModel.reload.sink(receiveValue: {
            self.collectionView.reloadData()
        })
        .store(in: &subscriptions)
        
    }
    
    fileprivate func configureRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        //fetchData(showLoader: false)
    }
    
//    func fetchData(showLoader: Bool) {
//        if showLoader {
//            showBlurLoader()
//        }
//        APIService.fetch(from: Constants.ALL_MOVIES_URL, of: Movies.self) { (movies, message) in
//            guard let movies = movies?.results else { return }
//            self.moviesRepresentable = self.createMovieRepresentable(from: movies)
//            self.collectionView.reloadData()
//            self.refreshControl.endRefreshing()
//        }
//
//        if showLoader {
//            self.removeBlurLoader()
//        }
//    }
//
//    private func createMovieRepresentable(from movies: [Movie]) -> [MovieRepresentable] {
//        var moviesTemp = [MovieRepresentable]()
//        for movie in movies {
//            if let movieEntity = MovieEntity.findByID(movie.id) {
//                let movieRepresentable = MovieRepresentable(movieEntity)
//                moviesTemp.append(movieRepresentable)
//            } else {
//                let movieRepresentable = MovieRepresentable(movie)
//                moviesTemp.append(movieRepresentable)
//            }
//        }
//
//        return moviesTemp
//    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(NowPlayingCollectionCell.self, forCellWithReuseIdentifier: NowPlayingCollectionCell.reuseIdentifier)
    }
}

//MARK: - CollectionViewDelegate
extension NowPlayingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.movies[indexPath.row].id
        
        let movieDetailsController = MovieDetailsViewController(movieId: id)
        
        navigationController?.pushViewController(movieDetailsController, animated: false)
    }
}

//MARK: - CollectionViewDataSource
extension NowPlayingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NowPlayingCollectionCell = collectionView.dequeue(for: indexPath)
    
        let movieRepresentable = viewModel.movies[indexPath.row]
        
        cell.configure(withMovieRepresentable: movieRepresentable)
        
        return cell
    }
}

//MARK: - CollectionViewFlowLayout
extension NowPlayingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  30
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: 250)
    }
}
