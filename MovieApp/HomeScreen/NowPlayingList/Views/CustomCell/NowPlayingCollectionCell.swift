//
//  NowPlayingCollectionCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 12/11/2020.
//

import UIKit
class NowPlayingCollectionCell: UICollectionViewCell {
    
    //MARK: Properties
    var id: Int!

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
        label.numberOfLines = 0
        label.textColor = .systemGray3
        label.font = UIFont(name: "ChalkboardSE-Bold", size: 18)
        return label
    }()
    
    let movieOverviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textColor = .systemGray3
        label.font = UIFont(name: "ArialMT", size: 13)
        return label
    }()
    
    let watchedButton: ActionButton = {
        let button = ActionButton(.watched)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let favouritesButton: ActionButton = {
        let button = ActionButton(.favourited)
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
    }
    
    fileprivate func setupAppearance() {
        self.backgroundColor = UIColor(named: "backgroundColor")
        contentView.backgroundColor = UIColor(named: "cellColor")
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
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
            make.height.equalTo(220)
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
        
        favouritesButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
            make.size.equalTo(35)
        }

        movieOverviewLabel.snp.makeConstraints { (make) in
            make.top.equalTo(movieTitleLabel.snp.bottom)
            make.leading.trailing.equalTo(moviePosterImageView).inset(5)
            make.bottom.equalTo(favouritesButton).inset(35)
            
        }

        watchedButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(favouritesButton).inset(40)
            make.bottom.equalTo(contentView.snp.bottom)
            make.size.equalTo(35)
        }
    }
}

//MARK: - Methods
extension NowPlayingCollectionCell {
    func configure(withMovieRepresentable movieRepresentable: MovieRepresentable) {
        self.id = movieRepresentable.id
        moviePosterImageView.setImageFromUrl(Constants.poster(path: movieRepresentable.posterPath))
        yearOfReleaseLabel.text = movieRepresentable.releaseDate.extractYear
        movieTitleLabel.text = movieRepresentable.title
        movieOverviewLabel.text = movieRepresentable.overview
        watchedButton.isSelected = movieRepresentable.watched
        favouritesButton.isSelected = movieRepresentable.favourited
        watchedButton.setAssociatedMovieId(id)
        favouritesButton.setAssociatedMovieId(id)
    }
}

