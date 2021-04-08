//
//  CollectionStatusViewModel.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit
//import DatePickerDialog

class CollectionStatusViewModel: NSObject {
    var arrOfBuildings = [Buildings]()
    var arrOfFlatNo = [Resident_data]()
    var arrOfRevenue_head = [Revenue_head]()
    var arrOfAmount = [AccountList]()
    
    var arrOfpending_dues = [AccountList]()
    var arrOfpayment_recievedDues = [AccountList]()
    var arrOfPaidDues = [AccountList]()
    
    typealias completion = (Bool,String) -> ()
    


    func openDatePickerFrom(strTimeAndDate:String, value: @escaping (String) -> Void) {

    }
    
    func openDatePickertill(fromDate:Date, value: @escaping (String) -> Void) {

    }
    
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

    func json_for_collection_status(society_id: String,building_id:String,flat_no:String,resident_id:String,head_id:String,mode:String,from_month_and_year:String,to_month_and_year:String,completeionHandler: @escaping completion) {
        let parameters:[String:Any] = ["society_id":society_id,
                                       "mode":mode,
                                       "building_id":building_id,
                                       "flat_no":flat_no,
                                       "resident_id":resident_id,
                                       "from_month_and_year":from_month_and_year,
                                       "head_id":head_id,
                                       "to_month_and_year":to_month_and_year]
        AuthenticationInterface.shared.json_for_collection_status(parameters:parameters) { (response, success, message) in
            if let list = response as? AccountPendingList, success {
                self.arrOfpending_dues = list.arrOfpending_dues ?? []
                self.arrOfpayment_recievedDues = list.arrOfpayment_recievedDues ?? []
                self.arrOfPaidDues = list.arrOfPaidDues ?? []
                completeionHandler(success,message ?? "")
            } else if let message = message {
                completeionHandler(success, message)
            }
        }
    }
}

struct CollectionStatusModel {
    var mode:String = "flat"
    var society_id:String?
    var building_id:String?
    var flat_no:String?
    var resident_id:String?
    var from_month_and_year:String?
    var to_month_and_year:String?
    var head_id:String?
    var selectedTab:CollectionStatusHistory = .Pending
    init() {
    }
    func headingData() ->[String] {
        return [CollectionStatusHistory.Pending.rawValue,
                CollectionStatusHistory.Paid.rawValue,
                CollectionStatusHistory.Payment.rawValue]
    }
}

enum CollectionStatusHistory:String {
    case Paid = "Paid"
    case Pending = "Pending"
    case Payment = "Payment"//for received payment
}
