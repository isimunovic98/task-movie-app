//
//  Extensions+UIView.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 03/11/2020.
//

import UIKit

extension UIView {
    func showBlurLoader(blurLoader: BlurLoader) {
        self.addSubview(blurLoader)
        NSLayoutConstraint.activate([
            blurLoader.topAnchor.constraint(equalTo: self.topAnchor),
            blurLoader.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurLoader.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blurLoader.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func removeBlurLoader(blurLoader: BlurLoader) {
        blurLoader.removeFromSuperview()
    }
}
