//
//  ResidentCollectionViewModel.swift
//  AccountManagement
//
//  Created by Sunil Kumar on 13/03/21.
//  Copyright © 2021 Wiantech. All rights reserved.
//

import UIKit
//import DatePickerDialog

class ResidentCollectionViewModel: NSObject {
    //ViewModel Class Variable decalration-
    var arrOfBuildings = [Buildings]()
    var arrOfFlatNo = [Resident_data]()
    var arrOfRevenue_head = [Revenue_head]()
    typealias completion = (Bool,String) -> ()
    
    
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
}

// Remove Repeated Value From an array-
extension Array {
    func uniques<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return reduce([]) { result, element in
            let alreadyExists = (result.contains(where: { $0[keyPath: keyPath] == element[keyPath: keyPath] }))
            return alreadyExists ? result : result + [element]
        }
    }
}

struct ResidentCollection {
    var society_id:String?
    var building_id:String?
    var flat_no:String?
    var resident_id:String?
    var amount:String?
    var head_id:String?
    var applied_date:String?
    var collection_for:String?
    var mode:String?
    var already_paid:String?
    var paid_amount:String?
    var mode_of_payment:String?
    var cheque_no:String?
    var isAutoAppliedOn:String?
    var image:UIImage?
    var appliedFromDate:String?
    var appliedTilDate:String?
    
    init() {
    }
}
