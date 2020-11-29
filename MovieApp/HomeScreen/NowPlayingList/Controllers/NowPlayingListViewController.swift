//
//  NowPlayingListViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 30/10/2020.
//

import UIKit

class NowPlayingListViewController: UIViewController {
        
    //MARK: Properties
    var movies = [Movie]()
    
    lazy var nowPlayingCollectionView: UICollectionView = {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nowPlayingCollectionView.reloadData()
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
        configureCollectionView()
        configureRefreshControl()
        fetchData(showLoader: true)
    }
    
    fileprivate func setupApperance() {
        view.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    fileprivate func addSubviews() {
        view.addSubview(nowPlayingCollectionView)
    }
    
    fileprivate func setupConstraints() {
        nowPlayingCollectionView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - Methods
extension NowPlayingListViewController {
    fileprivate func configureRefreshControl() {
        nowPlayingCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        fetchData(showLoader: false)
    }
    
    func fetchData(showLoader: Bool) {
        if showLoader {
            showBlurLoader()
        }
        APIService.fetch(from: Constants.ALL_MOVIES_URL, of: Movies.self) { (movies, message) in
            guard let movies = movies?.results else { return }
            self.movies = movies
            self.nowPlayingCollectionView.reloadData()
            self.removeBlurLoader()
            self.refreshControl.endRefreshing()
        }
    }
    
    func configureCollectionView() {
        nowPlayingCollectionView.delegate = self
        nowPlayingCollectionView.dataSource = self
        
        nowPlayingCollectionView.register(NowPlayingCollectionCell.self, forCellWithReuseIdentifier: NowPlayingCollectionCell.reuseIdentifier)
    }
}

//MARK: - CollectionViewDelegate
extension NowPlayingListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = movies[indexPath.row].id
        
        let movieDetailsController = MovieDetailsViewController(movieId: id)
        
        navigationController?.pushViewController(movieDetailsController, animated: false)
    }
}

//MARK: - CollectionViewDataSource
extension NowPlayingListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NowPlayingCollectionCell = collectionView.dequeue(for: indexPath)
    
        cell.configure(withMovie: movies[indexPath.row])
        
        return cell
    }
}

//MARK: - CollectionViewFlowLayout
extension NowPlayingListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  30
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: 250)
    }
}
