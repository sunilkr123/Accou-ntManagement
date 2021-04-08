//
//  UIViewControllerExtension.swift
//  IdentityX-Swift
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.
import Foundation
import UIKit

/// **UIViewController** : This extension use to shared behavior that is common to all view controllersr ** UIViewController **.
extension UIViewController: Threads {
    
    func setNavigationTitleFont(con:UIViewController) {
        con.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 21)]
    }
//    
    func isAmountSame(amount: String,confirmAmount: String) -> Bool {
        if amount == confirmAmount{
            return true
        }else{
            return false
        }
    }
    func changeDateformat(dateString: String,currentFomat:String, expectedFromat: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = currentFomat
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = expectedFromat
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    func applyShadowOnView(_ view:UIView) {
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
    }
}
extension String{
    func encodeUrl() -> String? {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    func decodeUrl() -> String? {
        return self.removingPercentEncoding
    }
}
