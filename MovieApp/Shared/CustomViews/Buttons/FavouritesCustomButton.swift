//
//  FavouritesCustomButton.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 04/11/2020.
//

import UIKit

class FavouritesCustomButton: UIButton, CustomButton {
    var type: CustomButtonType = .favourited
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(UIImage(named: "favouritesEmpty"), for: .normal)
        self.setImage(UIImage(named: "favouritesFilled"), for: .selected)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
