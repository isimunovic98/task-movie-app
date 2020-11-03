//
//  WatchedButton.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 02/11/2020.
//

import UIKit

class WatchedButton: UIView {
    
    //MARK: Properties
    let watchedButton: UIButton = {
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

extension WatchedButton {
    fileprivate func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(watchedButton)
        
        setupConstraints()
        configureButton()
    }
    
    fileprivate func setupConstraints() {
        let constraints = [
            watchedButton.topAnchor.constraint(equalTo: topAnchor),
            watchedButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            watchedButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            watchedButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    fileprivate func configureButton() {
        watchedButton.addTarget(self, action: #selector(isWatched), for: .touchUpInside)
        

        let watchedEmpty = UIImage(named: "watchedEmpty")
        let watchedFilled = UIImage(named: "watchedFilled")
        
        watchedButton.setImage(watchedEmpty, for: .normal)
        watchedButton.setImage(watchedFilled, for: .selected)
    }
    
    @objc func isWatched() {
        watchedButton.isSelected = !watchedButton.isSelected
    }
}

