//
//  FavouritesButton.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 02/11/2020.
//

import UIKit

class FavouritesButton: UIView {
    
    //MARK: Properties
    let favouritesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavouritesButton {
    fileprivate func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(favouritesButton)
        
        setupConstraints()
        configureButton()
    }
    
    fileprivate func setupConstraints() {
        let constraints = [
            favouritesButton.topAnchor.constraint(equalTo: topAnchor),
            favouritesButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            favouritesButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            favouritesButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    fileprivate func configureButton() {
        favouritesButton.addTarget(self, action: #selector(isFavourite), for: .touchUpInside)
        
        let favouritesEmpty = UIImage(named: "favouritesEmpty")
        let favouritesFilled = UIImage(named: "favouritesFilled")
        
        favouritesButton.setImage(favouritesEmpty, for: .normal)
        favouritesButton.setImage(favouritesFilled, for: .selected)
    }
    
    @objc func isFavourite() {
        favouritesButton.isSelected = !favouritesButton.isSelected
    }
}
