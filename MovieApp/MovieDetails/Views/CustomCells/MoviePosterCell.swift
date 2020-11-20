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
    
    //MARK: Init
    override required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMoviePoster(from url: String) {
        self.moviePosterImageView.setImageFromUrl(Constants.IMAGE_BASE_PATH + url)
    }
    
}

//MARK: UI
extension MoviePosterCell {
    
    func setupUI() {
        self.backgroundColor = UIColor(named: "cellColor")
        self.addSubview(moviePosterImageView)
        moviePosterImageView.addSubview(gradientLayer)
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        let constraints = [
            moviePosterImageView.topAnchor.constraint(equalTo: topAnchor),
            moviePosterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            moviePosterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            moviePosterImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            moviePosterImageView.heightAnchor.constraint(equalToConstant: 300),
            
            gradientLayer.topAnchor.constraint(equalTo: moviePosterImageView.topAnchor),
            gradientLayer.leadingAnchor.constraint(equalTo: moviePosterImageView.leadingAnchor),
            gradientLayer.trailingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor),
            gradientLayer.bottomAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
