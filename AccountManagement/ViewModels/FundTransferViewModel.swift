//
//  FundTransferViewModel.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 12/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit

class FundTransferViewModel: NSObject {
    //MARK:- Class Variable here -
    var arrOfExpense_head = [Expense_head]()
    var arrOfRevenue_head = [Revenue_head]()
    var totalAvailableFund = 0.0
    var totalOfExpenseHead = 0.0
    var totalOfRevenueHead = 0.0
    
    typealias completion = (Bool,String) -> ()
    
    func Fetch_all_head(society_id:String,completeionHandler: @escaping completion) {
        self.arrOfExpense_head.removeAll()
        self.arrOfRevenue_head.removeAll()
        totalAvailableFund = 0.0
        totalOfExpenseHead = 0.0
        totalOfRevenueHead = 0.0
        AuthenticationInterface.shared.fetch_all_head_API(society_id: society_id) { (response, success, message) in
            if let list = response as? Fetch_all_head_Model, success {
                self.arrOfExpense_head = list.arrOfExpense_head
                self.arrOfRevenue_head  = list.arrOfRevenue_head
                
                for i in 0..<self.arrOfExpense_head.count {
                    self.totalOfExpenseHead +=  Double(self.arrOfExpense_head[i].available_amount ?? "") ??  0.0
                }
                for i in 0..<self.arrOfRevenue_head.count {
                    self.totalOfRevenueHead +=  Double(self.arrOfRevenue_head[i].available_amount ?? "") ??  0.0
                }
                self.totalAvailableFund = self.totalOfExpenseHead + self.totalOfRevenueHead
                completeionHandler(success,message ?? "")
            } else if let message = message {
                completeionHandler(success,message )
            }
        }
    }
}

//For Head Selection
enum HeadName:String{
    case Revenue = "Revenue Head"
    case Expense = "Expenses Head"
}
