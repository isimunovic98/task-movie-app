//
//  WatchedFavouriteCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 05/11/2020.
//

import UIKit

class LabeledMoviesCell: UITableViewCell {
    
    //MARK: Properties
    var button: ActionButton?
    
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
extension LabeledMoviesCell {
    override func prepareForReuse() {
        if let button = button {
            button.removeFromSuperview()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
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
            make.top.leading.equalTo(contentView)
            make.size.equalTo(135)
        })
        
        yearOfReleaseLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(moviePosterImageView)
            make.centerX.equalTo(moviePosterImageView)
        }
        
        movieTitleLabel.snp.makeConstraints { (make) in
            make.top.trailing.equalTo(contentView).inset(10)
            make.leading.equalTo(moviePosterImageView.snp.trailing).offset(10)
        }
        
        movieOverviewLabel.snp.makeConstraints { (make) in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(movieTitleLabel)
        }
        
    }

}

//MARK: - Methods
extension LabeledMoviesCell {
    
    func configure(withMovieRepresentable movieRepresentable: MovieRepresentable, forType type: LabeledMoviesType) {
        moviePosterImageView.setImageFromUrl(Constants.poster(path: movieRepresentable.posterPath))
        yearOfReleaseLabel.text = movieRepresentable.releaseDate.extractYear
        movieTitleLabel.text = movieRepresentable.title
        movieOverviewLabel.text = movieRepresentable.overview
        setupButton(forType: type)
        button?.setAssociatedMovieId(movieRepresentable.id)
        
        if type == .watched {
             button?.isSelected = movieRepresentable.watched
         } else {
             button?.isSelected = movieRepresentable.favourited
         }
    }
    
    fileprivate func setupButton(forType type: LabeledMoviesType) {
        
        if type == .watched {
            button = getWatchedListButton()
        } else {
            button = getFavouriteListButton()
        }
    }
}

//MARK - Button Logic
extension LabeledMoviesCell {
    
    fileprivate func getWatchedListButton() -> ActionButton {
        
        let interactionButton: ActionButton = {
            let button = ActionButton(.watched)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.isSelected = true
            return button
        }()
        
        contentView.addSubview(interactionButton)
        setButtonConstraints(interactionButton)
        
        return interactionButton
    }
    
    fileprivate func getFavouriteListButton() -> ActionButton {
        
        let interactionButton: ActionButton = {
            let button = ActionButton(.favourited)
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
