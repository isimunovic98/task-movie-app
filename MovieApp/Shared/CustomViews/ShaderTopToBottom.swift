//
//  ShaderTopToBottom.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 12/11/2020.
//

import UIKit

class ShaderTopToBottom: UIView {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.withAlphaComponent(1).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        layer.insertSublayer(gradient, at: 0)
    }
}
