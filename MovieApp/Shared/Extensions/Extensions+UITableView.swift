//
//  Extensions+UITableView.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 03/11/2020.
//

import UIKit

extension UITableView {
    func dequeue<T: UITableViewCell> (for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable table view cell")
        }
        return cell
    }
}
