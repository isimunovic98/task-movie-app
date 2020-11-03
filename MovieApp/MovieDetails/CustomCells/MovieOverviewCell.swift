//
//  MovieDescriptionCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 02/11/2020.
//

import UIKit

class MovieOverviewCell: UITableViewCell {

    //MARK: Properties
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = label.font.withSize(25)
        label.text = "Description:"
        return label
    }()
    
    let movieOverviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray3
        label.numberOfLines = 0
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
    
    func setMovieOverview(overview: String) {
        movieOverviewLabel.text = overview
    }
    
}

//MARK: UI
extension MovieOverviewCell {
    
    func setupUI() {
        self.backgroundColor = UIColor(named: "cellColor")
        self.addSubview(descriptionLabel)
        self.addSubview(movieOverviewLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraints = [
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            movieOverviewLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            movieOverviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            movieOverviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieOverviewLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

}
