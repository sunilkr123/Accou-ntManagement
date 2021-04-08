//
//  TableViewExtension.swift
//  SlideMenuControllerSwift
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.
import UIKit

public extension UITableView {
    
    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func setBackGroundTheme(){
        self.tableFooterView = UIView()
        self.separatorColor = UIColor(red:1.0 , green: 1.0, blue: 1.0, alpha: 0.6)
        self.backgroundColor = UIColor.clear
    }
}
