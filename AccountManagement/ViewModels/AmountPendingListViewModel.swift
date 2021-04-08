//
//  AmountPendingListViewModel.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit
//import DatePickerDialog

class AmountPendingListViewModel: NSObject {
    
    //MARK:- Class Variable here -
    var arrOfBuildings = [Buildings]()
    var arrOfFlatNo = [Resident_data]()
    var arrOfRevenue_head = [Revenue_head]()
    typealias completion = (Bool,String) -> ()
    var arrOfAmount = [AccountList]()
    
    //calling api
    func json_for_society_details(society_id:String,building_id:String,completeionHandler: @escaping completion) {
        arrOfBuildings.removeAll()
        AuthenticationInterface.shared.json_for_society_details(society_id: society_id, building_id: building_id) { (response, success, message) in
            if let list = response as? BuildingModel, success {
                self.arrOfBuildings = list.arrOfBuidings.uniques(by: \.building_id)
                completeionHandler(success,message ?? "")
            } else if let message = message {
                completeionHandler(success,message )
            }
        }
    }
    //
    func json_for_society_details1(society_id:String,building_id:String,completeionHandler: @escaping completion) {
        arrOfFlatNo.removeAll()
        AuthenticationInterface.shared.json_for_society_details(society_id: society_id, building_id: building_id) { (response, success, message) in
            if let list = response as? FlatModel, success {
                self.arrOfFlatNo = list.arrResident_data.uniques(by: \.resident_flat_no)
                completeionHandler(success,message ?? "")
            } else if let message = message {
                completeionHandler(success,message )
            }
        }
    }
    //
    func Fetch_all_head(society_id:String,completeionHandler: @escaping completion) {
        
        AuthenticationInterface.shared.fetch_all_head_API(society_id: society_id) { (response, success, message) in
            if let list = response as? Fetch_all_head_Model, success {
                self.arrOfRevenue_head  = list.arrOfRevenue_head
                completeionHandler(success,message ?? "")
            } else if let message = message {
                completeionHandler(success,message)
            }
        }
    }
    //
    func fetch_all_account_pendingList(society_id: String,
                                       building_id:String,
                                       mode:String,
                                       from_month_and_year:String,
                                       to_month_and_year:String,
                                       flat_no:String,
                                       type:String,
                                       completeionHandler:@escaping completion)  {
        AuthenticationInterface.shared.fetchAllAccountPendinglist(society_id: society_id, building_id: building_id, mode: mode, from_month_and_year: from_month_and_year, type: type, to_month_and_year: to_month_and_year, flat_no: flat_no) { (response, success, msg) in
            if let list = response as? AccountPendingList, success {
                self.arrOfAmount = list.arrOfAmount
                completeionHandler(success,msg ?? "")
            } else if let message = msg {
                completeionHandler(success, message)
            }
        }
    }
}
