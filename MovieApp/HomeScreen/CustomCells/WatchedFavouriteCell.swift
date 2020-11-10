//
//  WatchedFavouriteCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 05/11/2020.
//

import UIKit

class WatchedFavouriteCell: UITableViewCell {
    
    //MARK: Properties
    var movie: MovieEntity?
    
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
        moviePosterImageView.snp.makeConstraints({ (make) in
            make.top.leading.bottom.equalTo(contentView)
            make.size.equalTo(150)
        })
        
        yearOfReleaseLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(moviePosterImageView)
            make.centerX.equalTo(moviePosterImageView)
        }
        
        movieTitleLabel.snp.makeConstraints { (make) in
            make.top.trailing.equalTo(contentView).inset(10)
            make.leading.equalTo(moviePosterImageView.snp.trailing).offset(10)
            make.bottom.equalTo(movieOverviewLabel.snp.top)
        }
        
        movieOverviewLabel.snp.makeConstraints { (make) in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(movieTitleLabel)
        }
        
    }
}

//MARK: - Methods
extension WatchedFavouriteCell {
    
    func configure(withMovie movie: MovieEntity, forType type: String) {
        self.movie = movie
        moviePosterImageView.setImageFromUrl(from: NowPlayingCell.posterPath + movie.posterPath!)
        yearOfReleaseLabel.text = movie.releaseDate?.extractYear
        movieTitleLabel.text = movie.title
        movieOverviewLabel.text = movie.overview
        setupButton(forType: type)
    }
    
    fileprivate func setupButton(forType type: String) {
        
        if type == WatchedListViewController.reuseIdentifier {
            button = getWatchedListButton()
            self.button?.addTarget(self, action: #selector(watchedButtonTapped), for: .touchUpInside)
        } else {
            button = getFavouriteListButton()
            self.button?.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        }
    }
    
    //MARK: Actions
    
    @objc func watchedButtonTapped() {
        button?.isSelected = false
        
        CoreDataHelper.updateWatched(withId: movie!.id, false)
    }
    
    @objc func favouriteButtonTapped() {
        button?.isSelected = false
        
        CoreDataHelper.updateFavourite(withId: movie!.id, false)
    }
}

//MARK - Button Logic
extension WatchedFavouriteCell {
    
    fileprivate func getWatchedListButton() -> WatchedCustomButton {
        
        let interactionButton: WatchedCustomButton = {
            let button = WatchedCustomButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.isSelected = true
            return button
        }()
        
        contentView.addSubview(interactionButton)
        setButtonConstraints(interactionButton)
        
        return interactionButton
    }
    
    fileprivate func getFavouriteListButton() -> FavouritesCustomButton {
        
        let interactionButton: FavouritesCustomButton = {
            let button = FavouritesCustomButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.isSelected = true
            return button
        }()
        
        contentView.addSubview(interactionButton)
        setButtonConstraints(interactionButton)
        
        return interactionButton
    }
    
    fileprivate func setButtonConstraints(_ button: UIButton) {
        button.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-10)
            make.height.width.equalTo(45)
        }
        movieOverviewLabel.bottomAnchor.constraint(equalTo: button.topAnchor).isActive = true
    }
}
