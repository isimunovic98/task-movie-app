//
//  WatchedCustomButton.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 04/11/2020.
//

import UIKit

class WatchedCustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(UIImage(named: "watchedEmpty"), for: .normal)
        self.setImage(UIImage(named: "watchedFilled"), for: .selected)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
