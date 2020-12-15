//
//  CustomButton.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 11.12.2020..
//

import UIKit

enum ActionButtonType {
    case watched
    case favourited
}

class ActionButton: UIButton {
    var associatedMovieId: Int?
    var type: ActionButtonType
    
    var buttonTapped: ((ActionButton) -> Void)?
    
    init(_ type: ActionButtonType) {
        self.type = type
        super.init(frame: .zero)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        switch type {
        case .watched:
            self.setImage(UIImage(named: "watchedEmpty"), for: .normal)
            self.setImage(UIImage(named: "watchedFilled"), for: .selected)
        case .favourited:
            self.setImage(UIImage(named: "favouritesEmpty"), for: .normal)
            self.setImage(UIImage(named: "favouritesFilled"), for: .selected)
        }
    }
    
    func setAssociatedMovieId(_ id: Int) {
        self.associatedMovieId = id
    }

    @objc func tapped() {
        buttonTapped?(self)
    }
}
