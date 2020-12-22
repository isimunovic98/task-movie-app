//
//  Extensions+UIView.swift
//  MovieApp
//
//  Created by Ivan Simunovic on 22.12.2020..
//

import UIKit

extension UIView
{
  func roundCorners(corners:UIRectCorner, radius: CGFloat)
  {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}
