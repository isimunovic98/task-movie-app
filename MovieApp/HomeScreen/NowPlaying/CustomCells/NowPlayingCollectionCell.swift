//
//  NowPlayingCollectionCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 12/11/2020.
//

import UIKit

protocol NowPlayingCellDelegate: class {
    func onWatchedTapped(for movieRepresentable: MovieRepresentable)
    func onFavouritesTapped(for movieRepresentable: MovieRepresentable)
}
class NowPlayingCollectionCell: UICollectionViewCell {
    
    //MARK: Properties
    var movieRepresentable: MovieRepresentable?
    
    weak var cellDelegate: NowPlayingCellDelegate?
    
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
            make.edges.equalTo(moviePosterImageView)
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
    func configure(withMovie movie: MovieRepresentable) {
        self.movieRepresentable = movie
        self.moviePosterImageView.setImageFromUrl(Constants.IMAGE_BASE_PATH + movie.posterPath)
        yearOfReleaseLabel.text = movie.releaseDate.extractYear
        movieTitleLabel.text = movie.title
        movieOverviewLabel.text = movie.overview
        watchedButton.isSelected = movie.watched
        favouritesButton.isSelected = movie.favourite
    }
    
    fileprivate func setupButtonActions() {
        watchedButton.addTarget(self, action: #selector(watchedButtonTapped), for: .touchUpInside)
        favouritesButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
    }
        
    //MARK: Actions
    @objc func watchedButtonTapped() {
        guard let movieRepresentable = movieRepresentable else {
            return
        }
        cellDelegate?.onWatchedTapped(for: movieRepresentable)
    }
    
    @objc func favouriteButtonTapped() {
        guard let movieRepresentable = movieRepresentable else {
            return
        }
        cellDelegate?.onFavouritesTapped(for: movieRepresentable)
    }
}
