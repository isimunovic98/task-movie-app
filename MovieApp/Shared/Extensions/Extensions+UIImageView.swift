//
//  Extensions+UIImageView.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 02/11/2020.
//

import UIKit

extension UIImageView {
    func setImageFromUrl(from url: String) {
        let url = URL(string: url)

        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url!) else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}
