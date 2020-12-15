//
//  MovieQuoteCell.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 02/11/2020.
//

import UIKit

class MovieQuoteCell: UITableViewCell {
    
    //MARK: Properties
    let quoteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = label.font.withSize(25)
        label.text = "Quote:"
        return label
    }()
    
    let movieQuoteLabel: UILabel = {
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
    
    func setMovieQuote(quote: String) {
        movieQuoteLabel.text = quote
    }
    
}

//MARK: UI
extension MovieQuoteCell {
    
    func setupUI() {
        self.backgroundColor = UIColor(named: "cellColor")
        self.addSubview(quoteLabel)
        self.addSubview(movieQuoteLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraints = [
            quoteLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            quoteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            quoteLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            movieQuoteLabel.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 15),
            movieQuoteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            movieQuoteLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieQuoteLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
