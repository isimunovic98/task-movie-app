//
//  NowPlayingCollectionCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 12/11/2020.
//

import UIKit

class NowPlayingCollectionCell: UICollectionViewCell {
    
    //MARK: Properties
    var movieRepresentable: MovieRepresentable?

    let moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let yearOfReleaseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray3
        label.font = label.font.withSize(20)
        return label
    }()
    
    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = .systemGray3
        label.font = label.font.withSize(15)
        return label
    }()
    
    let movieOverviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textColor = .systemGray3
        label.font = label.font.withSize(10)
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
    
    let gradientLayer: ShaderTopToBottom = {
       let layer = ShaderTopToBottom()
        layer.translatesAutoresizingMaskIntoConstraints = false
        return layer
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
        setupButtonActions()
    }
    
    fileprivate func setupAppearance() {
        self.backgroundColor = UIColor(named: "backgroundColor")
        contentView.backgroundColor = UIColor(named: "cellColor")
        contentView.layer.cornerRadius = 15
    }
    
    fileprivate func addSubviewsToContentView() {
        contentView.addSubview(moviePosterImageView)
        moviePosterImageView.addSubview(gradientLayer)
        contentView.addSubview(yearOfReleaseLabel)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(movieOverviewLabel)
        contentView.addSubview(watchedButton)
        contentView.addSubview(favouritesButton)
    }
    
    fileprivate func setupConstraints() {
        
        moviePosterImageView.snp.makeConstraints({ (make) in
            make.top.width.equalTo(contentView)
            make.height.equalTo(150)
        })
    
        yearOfReleaseLabel.snp.makeConstraints { (make) in
            make.bottom.centerX.equalTo(moviePosterImageView)
        }

        gradientLayer.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(moviePosterImageView)
        }
        
        movieTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(moviePosterImageView.snp.bottom)
            make.leading.trailing.equalTo(moviePosterImageView).inset(5)
        }

        movieOverviewLabel.snp.makeConstraints { (make) in
            make.top.equalTo(movieTitleLabel.snp.bottom)
            make.leading.trailing.equalTo(moviePosterImageView).inset(5)
            make.bottom.equalTo(favouritesButton.snp.top)
            
        }
        favouritesButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
            make.height.width.equalTo(45)
        }

        watchedButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(favouritesButton.snp.leading)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.width.equalTo(45)
        }
    }
}

//MARK: - Methods
extension NowPlayingCollectionCell {
    func configure(withMovieRepresentable movieRepresentable: MovieRepresentable) {
        self.movieRepresentable = movieRepresentable
        moviePosterImageView.setImageFromUrl(Constants.IMAGE_BASE_PATH + movieRepresentable.posterPath)
        yearOfReleaseLabel.text = movieRepresentable.releaseDate.extractYear
        movieTitleLabel.text = movieRepresentable.title
        movieOverviewLabel.text = movieRepresentable.overview
        watchedButton.isSelected = movieRepresentable.watched
        favouritesButton.isSelected = movieRepresentable.favourite
    }
    
    fileprivate func setupButtonActions() {
        watchedButton.addTarget(self, action: #selector(watchedButtonTapped), for: .touchUpInside)
        favouritesButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
    }

    
    //MARK: Actions
    @objc func watchedButtonTapped() {
        guard let movieRepresentable = movieRepresentable else { return }
        movieRepresentable.watched = !movieRepresentable.watched
        watchedButton.isSelected = movieRepresentable.watched
        CoreDataHelper.saveOrUpdate(movieRepresentable)
    }
    
    @objc func favouriteButtonTapped() {
        guard let movieRepresentable = movieRepresentable else { return }
        movieRepresentable.favourite = !movieRepresentable.favourite
        favouritesButton.isSelected = movieRepresentable.favourite
        CoreDataHelper.saveOrUpdate(movieRepresentable)
    }
}

