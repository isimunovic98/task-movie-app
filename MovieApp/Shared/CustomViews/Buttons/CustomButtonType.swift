//
//  ButtonTypes.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 04.12.2020..
//

import Foundation

enum CustomButtonType {
    case watched
    case favourited
}

protocol CustomButton {
    var type: CustomButtonType { get }
}
