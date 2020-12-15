//
//  LabeledMoviesListViewController.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 12.12.2020..
//

import UIKit
import Combine

class LabeledMoviesListViewController: UIViewController {
    
    //MARK: Properties
    var viewModel: LabeledMoviesViewModel
    
    var subscriptions = Set<AnyCancellable>()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        return tableView
    }()
    
    init(viewModel: LabeledMoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Lifecycle
extension LabeledMoviesListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchScreenDataSubject.send()
    }
    
}

//MARK: - UI
extension LabeledMoviesListViewController {
    
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
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
    }
}

//MARK: - Methods
extension LabeledMoviesListViewController {
    func setupBindings(){
        viewModel.fetchScreenData(from: viewModel.fetchScreenDataSubject).store(in: &subscriptions)
        
        viewModel.screenDataReadySubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &subscriptions)
        
        let buttonTappedListener = viewModel.attachActionButtonClickListener(listener: viewModel.actionButtonTappedSubject)
        buttonTappedListener.store(in: &subscriptions)
    }
    
}

//MARK: - TableViewDelegate
extension LabeledMoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LabeledMoviesCell = tableView.dequeue(for: indexPath)
        
        let movieRepresentable = viewModel.screenData[indexPath.row]
        
        cell.configure(withMovieRepresentable: movieRepresentable, forType: viewModel.type)
        
        cell.button?.buttonTapped = { [weak self] button in
            self?.viewModel.actionButtonTappedSubject.send(button)
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.screenData.count
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
        
        tableView.register(LabeledMoviesCell.self, forCellReuseIdentifier: LabeledMoviesCell.reuseIdentifier)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
