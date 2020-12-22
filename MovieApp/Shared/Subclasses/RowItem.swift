//
//  RowItem.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 02/11/2020.
//

import Foundation

struct RowItem {
     var content: Any
     var type: MovieDetailsCellTypes

     init(content: Any, type: MovieDetailsCellTypes) {
         self.content = content
         self.type = type
     }
}

struct InfoItem {
     var posterPath: String
     var watched: Bool
     var favourited: Bool

     init(posterPath: String, watched: Bool, favourited: Bool) {
         self.posterPath = posterPath
         self.watched = watched
         self.favourited = favourited
     }
    
    mutating func switchWatched() {
        self.watched = !watched
    }
    
    mutating func switchFavourited() {
        self.favourited = !favourited
    }
 }
