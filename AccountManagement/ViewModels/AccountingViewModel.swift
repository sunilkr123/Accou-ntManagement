//
//  AccountingViewModel.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit

class AccountingViewModel: NSObject {

    var arrayOfAccType = [AccountTypeModel]()
    
    func setStaticData(){
        let f1 = AccountTypeModel(name: "Head Management")
        let f2 = AccountTypeModel(name: "Fund Transfer")
        let f3 = AccountTypeModel(name: "Payments")
        let f4 = AccountTypeModel(name: "Resident Collection")
        let f5 = AccountTypeModel(name: "Third Party Collection")
        let f6 = AccountTypeModel(name: "Accounting Status")
        let f7 = AccountTypeModel(name: "Amount Pending List")
        self.arrayOfAccType = [f1,f2,f3,f4,f5,f6,f7]
    }
}

struct AccountTypeModel {
    var name:String?
}
