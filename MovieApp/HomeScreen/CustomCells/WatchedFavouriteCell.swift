//
//  WatchedFavouriteCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 05/11/2020.
//

import UIKit

class WatchedFavouriteCell: UITableViewCell {

    //MARK: Properties
    var movie: MovieAppMovie?

    var button: UIButton?
    
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
extension WatchedFavouriteCell {
    fileprivate func setupUI() {
        setupAppearance()
        addSubviewsToContentView()
        setupConstraints()
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
            movieOverviewLabel.trailingAnchor.constraint(equalTo: movieTitleLabel.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

//MARK: - Methods
extension WatchedFavouriteCell {
    
    func configure(withMovie movie: MovieAppMovie) {
        self.movie = movie
        moviePosterImageView.setImageFromUrl(from: NowPlayingCell.posterPath + movie.posterPath!)
        yearOfReleaseLabel.text = movie.releaseDate?.extractYear
        movieTitleLabel.text = movie.title
        movieOverviewLabel.text = movie.overview
        setupButton()
    }
    
    fileprivate func setupButton() {
        
        let interactionButton: WatchedCustomButton = {
            let button = WatchedCustomButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        contentView.addSubview(interactionButton)
        
        interactionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        interactionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        interactionButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        interactionButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        movieOverviewLabel.bottomAnchor.constraint(equalTo: interactionButton.topAnchor).isActive = true
        
        button = interactionButton
        button?.isSelected = true
        setupButtonAction()
    }
    
    fileprivate func setupButtonAction() {
        self.button?.addTarget(self, action: #selector(watchedButtonTapped), for: .touchUpInside)
    }
    
    //MARK: Actions

    @objc func watchedButtonTapped() {
        button?.isSelected = false
        //remove from core data and from tableview
        
        CoreDataHelper.updateWatched(withId: movie!.id, false)
    }
}
