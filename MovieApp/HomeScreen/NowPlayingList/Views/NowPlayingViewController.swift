//
//  NowPlayingListViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 30/10/2020.
//

import UIKit
import Combine

class NowPlayingViewController: UIViewController {
    private var viewModel: NowPlayingViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let changeButtonStatePublisher = PassthroughSubject<Bool, Never>()
        
    //MARK: Properties
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
    
    //MARK: Init
    init(viewModel: NowPlayingViewModel = NowPlayingViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Lifecycle
extension NowPlayingViewController {
   
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for subscription in subscriptions {
            subscription.cancel()
        }
    }
}

//MARK: - UI
extension NowPlayingViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupUI() {
        setupApperance()
        addSubviews()
        setupConstraints()
        configureCollectionView()
        configureRefreshControl()
    }
    
    private func setupApperance() {
        view.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - Methods
extension NowPlayingViewController {
    private func setupBindings() {
        subscriptions.insert(viewModel.fetchItems())
        
        viewModel.$movies
            .sink(receiveCompletion: { [weak self] _ in
                self?.collectionView.reloadData()
            }, receiveValue: { _ in})
            .store(in: &subscriptions)
        
        print(viewModel.movies.count)
    }
    
    private func configureRefreshControl() {
        collectionView.refreshControl = refreshControl
        //refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func configureCollectionView() {
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
