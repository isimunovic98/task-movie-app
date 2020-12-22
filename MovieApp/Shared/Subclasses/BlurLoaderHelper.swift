//
//  test.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 13.11.2020..
//

import UIKit

class BlurLoaderHelper {
    
    static let blurLoader: BlurLoader = {
        let view = BlurLoader()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    static func addBlurLoader(to view: UIView) {
        view.addSubview(blurLoader)
        NSLayoutConstraint.activate([
            blurLoader.topAnchor.constraint(equalTo: view.topAnchor),
            blurLoader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurLoader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurLoader.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    static func removeBlurLoader() {
        blurLoader.removeFromSuperview()
    }
}
