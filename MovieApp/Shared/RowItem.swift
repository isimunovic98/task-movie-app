//
//  RowItem.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 02/11/2020.
//

import Foundation

class RowItem {
    var content: Any
    var type: MovieDetailsCellTypes
    
    init(content: Any, type: MovieDetailsCellTypes) {
        self.content = content
        self.type = type
    }
}
