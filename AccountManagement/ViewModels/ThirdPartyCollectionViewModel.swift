//
//  ThirdPartyCollectionViewModel.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit

class ThirdPartyCollectionViewModel: NSObject {
    
    var arrOfParty = [Party_head]()
     var arrOfTransaction = [TransactionModel]()
    typealias completion = (Bool,String) -> ()
    func Fetch_allthird_party_head(society_id:String,completeionHandler: @escaping completion) {
        AuthenticationInterface.shared.fetch_third_party_receivable(society_id: society_id) { (response, success, message) in
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
        AuthenticationInterface.shared.fetch_all_transaction(society_id: society_id, party_id: party_id, urlString: APIEndPoints.fetch_third_party_transaction_all) { (response, success, message) in
            if let list = response as? Party_Transaction_Model, success {
                self.arrOfTransaction = list.arrOfTransactions!
                completeionHandler(success,message ?? "")
            } else if let message = message {
                completeionHandler(success,message ?? "")
            }
        }
    }
}
