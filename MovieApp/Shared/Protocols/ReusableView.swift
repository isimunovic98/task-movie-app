//
//  ReusableView.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 03/11/2020.
//

import Foundation

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
