//
//  MovieTitleCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 02/11/2020.
//

import UIKit

class MovieTitleCell: UITableViewCell {

    //MARK: Properties
    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = label.font.withSize(30)
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
    
    
    func setMovieTitle(title: String) {
        movieTitleLabel.text = title
    }
    
}

//MARK: UI
extension MovieTitleCell {
    
    func setupUI() {
        self.backgroundColor = UIColor(named: "cellColor")
        self.addSubview(contentView)
        
        contentView.addSubview(movieTitleLabel)
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraints = [
            movieTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            movieTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
