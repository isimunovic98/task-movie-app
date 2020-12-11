//
//  FavouriteListViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 09/11/2020.
//
import UIKit
import Combine

class FavouriteListViewController: UIViewController, ReusableView {
    //MARK: Properties
    var viewModel: FavouritesViewModel
    
    var subscriptions = Set<AnyCancellable>()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        return tableView
    }()

    init(viewModel: FavouritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Lifecycle
extension FavouriteListViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
}

//MARK: - UI
extension FavouriteListViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupUI() {
        setupAppearance()
        addSubviews()
        setupConstraints()
        configureTableView()
    }
    
    fileprivate func setupAppearance() {
        view.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    fileprivate func addSubviews() {
        view.addSubview(tableView)
    }
    
    fileprivate func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }
        
    }
}

//MARK: - Methods
extension FavouriteListViewController {
    func setupBindings(){
        viewModel.screenDataReadySubject
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &subscriptions)
        
        let buttonTappedListener = viewModel.attachButtonTappedListener(listener: viewModel.buttonTappedSubject)
        buttonTappedListener.store(in: &subscriptions)
    }
}

extension FavouriteListViewController: CellDelegate {
    func onButtonTapped(ofId id: Int) {
        viewModel.buttonTappedSubject.send(id)
    }
    
}


//MARK: - TableViewDelegate
extension FavouriteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WatchedFavouriteCell = tableView.dequeue(for: indexPath)
        
        let movieRepresentable = viewModel.screenData[indexPath.row]
        
        cell.configure(withMovieRepresentable: movieRepresentable, forType: FavouriteListViewController.reuseIdentifier)
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.screenData.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = viewModel.screenData[indexPath.row].id
        
        let movieDetailsController = MovieDetailsViewController(movieId: id)
        
        navigationController?.pushViewController(movieDetailsController, animated: false)
    }
    
    func configureTableView() {
        setTableViewDelegates()
        
        tableView.register(WatchedFavouriteCell.self, forCellReuseIdentifier: WatchedFavouriteCell.reuseIdentifier)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
