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
        blurLoader.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    static func removeBlurLoader() {
        blurLoader.removeFromSuperview()
    }
}
