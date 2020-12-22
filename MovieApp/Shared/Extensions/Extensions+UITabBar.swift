//
//  Extensions+UITabBar.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 22.12.2020..
//

import UIKit

extension UITabBar {
    static func setTransparentTabBar() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
    }
}
