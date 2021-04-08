//  DropDownCommon.swift
//  PickDeliVendor
//  Created by Sunil Kumar on 28/11/20.
//  Copyright © 2020 Wiantech. All rights reserved.


import Foundation
import UIKit

class DropDownCommon {
    
    //MARK:- Class Variables For Common for all Drop Down-
    static let shared = DropDownCommon() //Singleton pattern
    var arrOfDropDown = Array<DropDownDataModel>()
    public typealias onSelection = (String,Int) -> Void // On Selection of Items Closure-
}
//Function for All Drop_Down  Common Function
extension DropDownCommon {
    public func openDropDown(arrOfDropDown arr:[String],dropDown:DropDown) {
        self.arrOfDropDown.removeAll()
        DispatchQueue.main.async {
            for i in 0..<arr.count{
                let dataModel = DropDownDataModel()
                var dict = [String:Any]()
                dict["name"] = arr[i]
                dict["id"] = i
                dataModel.dataObject = dict as AnyObject
                dataModel.item = arr[i]
                self.arrOfDropDown.append(dataModel) //appending Value in dropDown
            }
            dropDown.dataSource = self.arrOfDropDown
        }
    }//
}
extension DropDownCommon {
    
    public func dropDown(view anchorView: UIView,dropDown: DropDown,onSelection: @escaping onSelection){
        dropDown.anchorView = anchorView
        dropDown.animationduration = 0.2
        dropDown.direction = .bottom
        dropDown.cellHeight = 40
        dropDown.shadowColor = .gray
        dropDown.shadowRadius = 5
        dropDown.shadowOpacity = 1
        dropDown.selectionBackgroundColor = .lightGray
        dropDown.textColor = .black
        dropDown.bottomOffset = CGPoint(x:0, y: anchorView.bounds.maxY)//
        dropDown.selectionAction = { (index, item) in
            onSelection(item.item ?? "",index + 1)
        }
    }
}

