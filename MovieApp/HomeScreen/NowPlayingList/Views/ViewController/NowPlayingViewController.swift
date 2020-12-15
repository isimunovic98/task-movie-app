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
    init(viewModel: NowPlayingViewModel) {
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
        //CoreDataHelper.deleteAllData()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.dataLoaderSubject.send(true)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        let loader = viewModel.fetchItems(with: viewModel.dataLoaderSubject)
        loader.store(in: &subscriptions)
        
        viewModel.shouldShowBlurLoaderSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] shouldShowLoader in
                self?.showLoader(shouldShowLoader)
            })
            .store(in: &subscriptions)
        
        viewModel.screenDataReadySubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .map({ [weak self] state in
                switch state {
                case .reloadAll:
                    self?.collectionView.reloadData()
                case .reloadCell(let index):
                    let indexPath = IndexPath(item: index, section: 0)
                    self?.collectionView.reloadItems(at: [indexPath])
                }
            })
            .sink(receiveValue: { _ in })
            .store(in: &subscriptions)
    
        viewModel.errorHandlerSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink{ [weak self] error in
                if error is NetworkError {
                    self?.presentJSONErrorAlert()
                } else {
                    self?.presentInvalidUrlAlert()
                }
            }
            .store(in: &subscriptions)
        
        viewModel.attachActionButtonClickListener(listener: viewModel.actionButtonTappedSubject).store(in: &subscriptions)
        
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
    
    private func configureRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(NowPlayingCollectionCell.self, forCellWithReuseIdentifier: NowPlayingCollectionCell.reuseIdentifier)
    }
    
    //MARK: Actions
    @objc func refresh() {
        viewModel.dataLoaderSubject.send(false)
        refreshControl.endRefreshing()
    }
}

//MARK: - CollectionViewDelegate
extension NowPlayingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = viewModel.screenData[indexPath.row].id
        
        let movieDetailsController = MovieDetailsViewController(movieId: id)
        
        navigationController?.pushViewController(movieDetailsController, animated: false)
    }
}

//MARK: - CollectionViewDataSource
extension NowPlayingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.screenData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NowPlayingCollectionCell = collectionView.dequeue(for: indexPath)
        
        let movieRepresentable = viewModel.screenData[indexPath.row]
        
        cell.configure(withMovieRepresentable: movieRepresentable)
        cell.watchedButton.buttonTapped = { [weak self] button in
            self?.processButtonTap(of: button)
        }
        cell.favouritesButton.buttonTapped = { [weak self] button in
            self?.processButtonTap(of: button)
        }
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
