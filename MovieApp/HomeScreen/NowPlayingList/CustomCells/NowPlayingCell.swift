//
//  NowPlayingCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 30/10/2020.
//

import UIKit

class NowPlayingCell: UITableViewCell {
    
    static var posterPath: String = "https://image.tmdb.org/t/p/w500/"
    
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension NowPlayingCell {
    fileprivate func setupUI() {
        setupAppearance()
        addSubviewsToContentView()
        setupConstraints()
        setupButtonActions()
    }
    
    fileprivate func setupAppearance() {
        selectionStyle = .none
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
        
        let constraints = [
            moviePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            moviePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moviePosterImageView.widthAnchor.constraint(equalToConstant: 150),
            moviePosterImageView.heightAnchor.constraint(equalToConstant: 150),
            moviePosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            yearOfReleaseLabel.centerXAnchor.constraint(equalTo: moviePosterImageView.centerXAnchor),
            yearOfReleaseLabel.bottomAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor),
            
            movieTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieTitleLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 10),
            movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            movieTitleLabel.bottomAnchor.constraint(equalTo: movieOverviewLabel.topAnchor),
            
            movieOverviewLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 5),
            movieOverviewLabel.leadingAnchor.constraint(equalTo: movieTitleLabel.leadingAnchor),
            movieOverviewLabel.trailingAnchor.constraint(equalTo: movieTitleLabel.trailingAnchor),
            movieOverviewLabel.bottomAnchor.constraint(equalTo: favouritesButton.topAnchor),
            
            favouritesButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            favouritesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favouritesButton.heightAnchor.constraint(equalToConstant: 45),
            favouritesButton.widthAnchor.constraint(equalToConstant: 45),
            
            watchedButton.trailingAnchor.constraint(equalTo: favouritesButton.leadingAnchor),
            watchedButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            watchedButton.heightAnchor.constraint(equalToConstant: 45),
            watchedButton.widthAnchor.constraint(equalToConstant: 45)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

//MARK: - Methods
extension NowPlayingCell {
    func configure(withMovie movie: Movie) {
        self.movie = movie
        moviePosterImageView.setImageFromUrl(from: NowPlayingCell.posterPath + movie.poster_path)
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
        if let movie = MovieAppMovie.findByID(Int64(movie!.id)) {
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
