//
//  MoviePosterCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 02/11/2020.
//

import UIKit

class MoviePosterCell: UITableViewCell {
    
    //MARK: Properties
    let moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let gradientLayer: ShaderBottomToTop = {
       let layer = ShaderBottomToTop()
        layer.translatesAutoresizingMaskIntoConstraints = false
        return layer
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
    
    //MARK: Init
    override required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: InfoItem) {
        moviePosterImageView.setImageFromUrl(Constants.poster(path: item.posterPath))
        watchedButton.isSelected = item.watched
        favouritesButton.isSelected = item.favourited
    }
    
}

//MARK: UI
extension MoviePosterCell {
    
    func setupUI() {
        backgroundColor = UIColor(named: "cellColor")
        contentView.addSubview(moviePosterImageView)
        contentView.addSubview(gradientLayer)
        contentView.addSubview(watchedButton)
        contentView.addSubview(favouritesButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        moviePosterImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
            make.height.equalTo(350)
        }
        
        gradientLayer.snp.makeConstraints { (make) in
            make.edges.equalTo(moviePosterImageView)
        }
    
        favouritesButton.snp.makeConstraints { (make) in
            make.top.equalTo(moviePosterImageView)
            make.trailing.equalTo(moviePosterImageView).offset(-15)
            make.size.equalTo(45)
        }
        
        watchedButton.snp.makeConstraints { (make) in
            make.top.equalTo(moviePosterImageView)
            make.trailing.equalTo(favouritesButton.snp.leading).offset(-15)
            make.size.equalTo(45)
        }
        
    }
}
