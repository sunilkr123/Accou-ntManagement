//
//  Fetch_all_head_ViewModel.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 12/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit

class Fetch_all_head_ViewModel: NSObject {
    
    var arrOfExpense_head = [Expense_head]()
    var arrOfRevenue_head = [Revenue_head]()
    typealias completion = (Bool,String) -> ()
    
    func Fetch_all_head(society_id:String,completeionHandler: @escaping completion) {
        AuthenticationInterface.shared.fetch_all_head_API(society_id: society_id) { (response, success, message) in
            if let list = response as? Fetch_all_head_Model, success {
                self.arrOfExpense_head = list.arrOfExpense_head
                self.arrOfRevenue_head  = list.arrOfRevenue_head
                completeionHandler(success,message ?? "")
            } else if let message = message {
                completeionHandler(success,message ?? "")
            }
        }
    }
}
//need to replace it
class headFetch {
    typealias completion = (Bool,String,([Expense_head],[Revenue_head])) -> ()
    var arrOfExpense_head = [Expense_head]()
    var arrOfRevenue_head = [Revenue_head]()
    init() {
    }
     func Fetch_all_head(society_id:String,completeionHandler: @escaping completion) {
        AuthenticationInterface.shared.fetch_all_head_API(society_id: society_id) { (response, success, message) in
            if let list = response as? Fetch_all_head_Model, success {
                completeionHandler(success,message ?? "", (list.arrOfExpense_head,list.arrOfRevenue_head))
            } else if let message = message {
                completeionHandler(success,message ?? "", ([],[]))
            }
        }
    }
}
