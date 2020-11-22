//
//  NowPlayingListViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 30/10/2020.
//

import UIKit

class NowPlayingViewController: UIViewController {
    
    //MARK: Properties
    var presenter: NowPlayingPresenter
    
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
    
    init(presenter: NowPlayingPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.getMovies(showLoader: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
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
    fileprivate func configureRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        presenter.getMovies(showLoader: false)
        refreshControl.endRefreshing()
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(NowPlayingCollectionCell.self, forCellWithReuseIdentifier: NowPlayingCollectionCell.reuseIdentifier)
    }
}

//MARK: - View Protocol
extension NowPlayingViewController: NowPlayingDelegate {
    
    func loading(_ shouldShowLoader: Bool){
        if shouldShowLoader {
            showBlurLoader()
        } else {
            removeBlurLoader()
        }
    }
    
    func reloadScreenData() {
        collectionView.reloadData()
    }
    
    func presentJsonError(_ message: String) {
        presentJSONErrorAlert(message)
    }
}

//MARK: - CollectionViewDelegate
extension NowPlayingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = presenter.movies[indexPath.row].id
        
        let presenter = MovieDetailsPresenter()
        let movieDetailsController = MovieDetailsViewController(presenter: presenter, movieId: Int(id))
        presenter.delegate = movieDetailsController
        
        navigationController?.pushViewController(movieDetailsController, animated: false)
    }
}

//MARK: - CollectionViewDataSource
extension NowPlayingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = presenter.movies[indexPath.row]
        
        let cell: NowPlayingCollectionCell = collectionView.dequeue(for: indexPath)
        
        cell.configure(withMovie: movie)
        
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
