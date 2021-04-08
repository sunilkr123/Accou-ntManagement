//
//  UILableFontExtension.swift
//  IdentityX-Swift
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.
import Foundation
import UIKit


/// A UILabel subclass that can hold attributes and apply them to text
fileprivate var _fontSize:CGFloat = 8.0
fileprivate var _fontName:String = "Lato-Regular"

extension UILabel {
    @IBInspectable
    var fontSize:CGFloat
    {
        get
        {
            return self.fontSize
        }
        set
        {
            self.font = UIFont(name: _fontName, size:  newValue)
        }
    }
    
    @IBInspectable
    var fontName:String
    {
        set
        {
            self.font = UIFont(name: newValue, size: _fontSize)
        }
        get
        {
            return self.fontName
        }
    }
}

/// this class used for change font daynamically according to device
class CommonMethods {
    static func heightRatio(objectHeight:CGFloat) -> CGFloat {
        return (objectHeight/667)*UIScreen.main.bounds.height
    }
    static func widthRatio(objectHeight:CGFloat) -> CGFloat {
        return (objectHeight/375)*UIScreen.main.bounds.width
    }
}
