//
//  Extensions+UICollectionView.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 12/11/2020.
//

import UIKit

extension UICollectionView {
    func dequeue<T: UICollectionViewCell> (for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable table view cell")
        }
        return cell
    }
}
