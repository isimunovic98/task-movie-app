//
//  NowPlayingCollectionCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 12/11/2020.
//

import UIKit

class NowPlayingCollectionCell: UICollectionViewCell {
    
    //MARK: Properties
    var movie: Movie?

    var favourite: Bool = false
    var watched: Bool = false
    
    let moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let yearOfReleaseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray3
        label.font = label.font.withSize(25)
        return label
    }()
    
    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = .systemGray3
        return label
    }()
    
    let movieOverviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textColor = .systemGray3
        return label
    }()
    
    let watchedButton: WatchedCustomButton = {
        let button = WatchedCustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let favouritesButton: FavouritesCustomButton = {
        let button = FavouritesCustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension NowPlayingCollectionCell {
    fileprivate func setupUI() {
        setupAppearance()
        addSubviewsToContentView()
        setupConstraints()
        //setupButtonActions()
    }
    
    fileprivate func setupAppearance() {
        self.backgroundColor = UIColor(named: "backgroundColor")
        contentView.backgroundColor = UIColor(named: "cellColor")
        contentView.layer.cornerRadius = 15
    }
    
    fileprivate func addSubviewsToContentView() {
        contentView.addSubview(moviePosterImageView)
        contentView.addSubview(yearOfReleaseLabel)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(movieOverviewLabel)
        contentView.addSubview(watchedButton)
        contentView.addSubview(favouritesButton)
    }
    
    fileprivate func setupConstraints() {
        
        moviePosterImageView.snp.makeConstraints({ (make) in
            make.size.equalTo(contentView)
        })
        
        yearOfReleaseLabel.snp.makeConstraints { (make) in
            make.bottom.centerX.equalTo(moviePosterImageView)
        }
//
//        movieTitleLabel.snp.makeConstraints { (make) in
//            make.top.trailing.equalTo(contentView).inset(10)
//            make.leading.equalTo(moviePosterImageView.snp.trailing).offset(10)
//            make.bottom.equalTo(movieOverviewLabel.snp.top)
//        }
//
//        movieOverviewLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(movieTitleLabel.snp.bottom).offset(5)
//            make.leading.trailing.equalTo(movieTitleLabel)
//            make.bottom.equalTo(favouritesButton.snp.top)
//        }
//        favouritesButton.snp.makeConstraints { (make) in
//            make.bottom.equalTo(contentView)
//            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
//            make.height.width.equalTo(45)
//        }
//
//        watchedButton.snp.makeConstraints { (make) in
//            make.trailing.equalTo(favouritesButton.snp.leading)
//            make.bottom.equalTo(contentView.snp.bottom)
//            make.height.width.equalTo(45)
//        }
    }
}

//MARK: - Methods
extension NowPlayingCollectionCell {
    func configure(withMovie movie: Movie) {
        self.movie = movie
        self.moviePosterImageView.setImageFromUrl(Constants.IMAGE_BASE_PATH + movie.poster_path)
        yearOfReleaseLabel.text = movie.release_date.extractYear
        movieTitleLabel.text = movie.title
        movieOverviewLabel.text = movie.overview
        setButtonStates()
    }
    
    fileprivate func setupButtonActions() {
        watchedButton.addTarget(self, action: #selector(watchedButtonTapped), for: .touchUpInside)
        favouritesButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
    }
    
    func setButtonStates() {
        if let movie = MovieEntity.findByID(Int64(movie!.id)) {
            watched = movie.watched
            favourite = movie.favourite
            watchedButton.isSelected = watched
            favouritesButton.isSelected = favourite
        } else {
            watchedButton.isSelected = false
            watchedButton.isSelected = false
        }
    }
    
    //MARK: Actions
    @objc func watchedButtonTapped() {
        watched = !watched
        watchedButton.isSelected = watched
        CoreDataHelper.saveOrUpdate(movie!, watched, favourite)
    }
    
    @objc func favouriteButtonTapped() {
        favourite = !favourite
        favouritesButton.isSelected = favourite
        CoreDataHelper.saveOrUpdate(movie!, watched, favourite)
    }
}

