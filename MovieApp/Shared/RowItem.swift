//
//  RowItem.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 02/11/2020.
//

import Foundation

class RowItem <ItemContent, ItemType>{
    var content: ItemContent
    var type: ItemType
    
    init(content: ItemContent, type: ItemType) {
        self.content = content
        self.type = type
    }
}
