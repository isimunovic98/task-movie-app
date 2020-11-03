//
//  MovieGenresCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 02/11/2020.
//

import UIKit

class MovieGenresCell: UITableViewCell {

    //MARK: Properties
    let movieGenresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray3
        return label
    }()
    
    //MARK: Init
    override required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMovieGenres(genres: [Genre]) {
        var genresTemp: String = ""
        for genre in genres {
            genresTemp.append("\(genre.name), ")
        }
        movieGenresLabel.text = String(genresTemp.dropLast(2))
    }
    
}

//MARK: UI
extension MovieGenresCell {
    
    func setupUI() {
        self.backgroundColor = UIColor(named: "cellColor")
        self.addSubview(movieGenresLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraints = [
            movieGenresLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            movieGenresLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            movieGenresLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieGenresLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
