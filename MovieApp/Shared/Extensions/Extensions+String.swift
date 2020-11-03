//
//  Extensions+String.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 30/10/2020.
//

import Foundation

extension String {
    var extractYear: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: self) else {
            return nil
        }
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        return year
    }
}
