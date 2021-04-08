//
//  UIButtonExtension.swift
//  IdentityX-Swift
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.

import Foundation
import UIKit
/// **UIButton** : This extension use for set button border and botton corner radius and border color ** UIButton **.

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
//    @IBInspectable var cornerRadius: CGFloat {
//        set {
//            layer.cornerRadius = newValue
//        }
//        get {
//            return layer.cornerRadius
//        }
//    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
extension UIButton
{
      func roundedButton(){
          let maskPath1 = UIBezierPath(roundedRect: bounds,
              byRoundingCorners: [.bottomLeft ],
              cornerRadii: CGSize(width: 6, height: 6))
          let maskLayer1 = CAShapeLayer()
          maskLayer1.frame = bounds
          maskLayer1.path = maskPath1.cgPath
          layer.mask = maskLayer1
      }
  func roundedButtonRight(){
          let maskPath1 = UIBezierPath(roundedRect: bounds,
              byRoundingCorners: [.bottomRight],
              cornerRadii: CGSize(width: 6, height: 6))
          let maskLayer1 = CAShapeLayer()
          maskLayer1.frame = bounds
          maskLayer1.path = maskPath1.cgPath
          layer.mask = maskLayer1
      }
}
