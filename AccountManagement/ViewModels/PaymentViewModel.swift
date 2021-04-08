//
//  PaymentViewModel.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 13/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit
class PaymentViewModel: NSObject {
    
    var arrOfParty = [Party_head]()
    var arrOfTransaction = [TransactionModel]()
    typealias completion = (Bool,String) -> ()
    
    
    func Fetch_all_head(society_id:String,completeionHandler: @escaping completion) {
        AuthenticationInterface.shared.fetch_all_party_head(society_id: society_id) { (response, success, message) in
            if let list = response as? Party_Head_Model, success {
                self.arrOfParty = list.arrOfparty_head
                completeionHandler(success,message ?? "")
            } else if let message = message {
                completeionHandler(success,message ?? "")
            }
        }
    }
     
    func fetch_all_transaction(society_id:String,party_id:String,completeionHandler: @escaping completion){
        self.arrOfTransaction = []
        AuthenticationInterface.shared.fetch_all_transaction(society_id: society_id, party_id: party_id, urlString: APIEndPoints.fetch_party_transaction) { (response, success, message) in
            if let list = response as? Party_Transaction_Model, success {
                self.arrOfTransaction = list.arrOfTransactions!
                completeionHandler(success,message ?? "")
            } else if let message = message {
                completeionHandler(success,message ?? "")
            }
        }
    }

    func addPayment(society_id: String,party_id:String,transaction_done_by:String,head_id:String,head_name:String,gst:String,gst_no:String,amount:String, completion: @escaping completion){
        AuthenticationInterface.shared.payPayment(society_id: society_id, party_id: party_id, transaction_done_by: transaction_done_by, head_id: head_id, head_name: head_name, gst: gst, gst_no: gst_no, amount: amount) { (response, success, msg) in
            completion(success,msg ?? "")
        }
    }
}
