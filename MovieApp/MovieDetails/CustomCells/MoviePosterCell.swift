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
    

    
    //MARK: Init
    override required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMoviePoster(from url: String) {
        moviePosterImageView.setImageFromUrl(from:"https://image.tmdb.org/t/p/w500/" + url)
    }
    
}

//MARK: UI
extension MoviePosterCell {
    
    func setupUI() {
        self.backgroundColor = UIColor(named: "cellColor")
        self.addSubview(moviePosterImageView)
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        let constraints = [
            moviePosterImageView.topAnchor.constraint(equalTo: topAnchor),
            moviePosterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            moviePosterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            moviePosterImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            moviePosterImageView.heightAnchor.constraint(equalToConstant: 300),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
