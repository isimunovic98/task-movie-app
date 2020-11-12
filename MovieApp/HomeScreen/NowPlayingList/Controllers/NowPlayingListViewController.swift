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
    
    lazy var nowPlayingCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        return collectionView
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
        view.addSubview(blurLoader)
    }
    
    fileprivate func setupConstraints() {
        nowPlayingCollectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - Methods
extension NowPlayingListViewController {
    fileprivate func configureRefreshControl() {
        nowPlayingCollectionView.addSubview(refreshControl)
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
                self.nowPlayingCollectionView.reloadData()
                self.view.removeBlurLoader(blurLoader: self.blurLoader)
                self.refreshControl.endRefreshing()
            }
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
        let id = movies[indexPath.section * 2 + indexPath.row].id
        
        let movieDetailsController = MovieDetailsViewController(movieId: id)
        
        navigationController?.pushViewController(movieDetailsController, animated: false)
    }
}

//MARK: - CollectionViewDataSource
extension NowPlayingListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return movies.count/2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NowPlayingCollectionCell = collectionView.dequeue(for: indexPath)
        
        cell.configure(withMovie: movies[indexPath.section * 2 + indexPath.row])
        
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
