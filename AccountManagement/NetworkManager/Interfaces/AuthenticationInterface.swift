//
//  AuthenticationInterface.swift
//  NetworkManagerDemo
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.

import UIKit

class AuthenticationInterface: BaseInterface {
    
    static let shared = AuthenticationInterface()//singleton pattern
    
    //API's Method Declaration from Here-
    //API's Method Declaration from Here-
    
    //1. http://miscos.in/vhss/vhss_json_new/UserApp/fetch_all_head.php?
    func fetch_all_head_API(society_id: String, completion: @escaping APIResponseBlock) {
        let urlString = APIEndPoints.fetch_all_head
        let parameters:[String:Any] = ["society_id":society_id]
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    let model = Fetch_all_head_Model(apiSuccess.json)
                    completion(model, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
    
    //2.http://miscos.in/vhss/vhss_json_new/UserApp/add_expencess_head.php
    func add_expencess_head(society_id:String,type_head:String,single_payment_limit:String,head_fund_limit:String,head_name:String,completion: @escaping APIResponseBlock) {
        
        let parameters:[String:Any] = ["society_id":society_id,
                                       "type_head":type_head,
                                       "single_payment_limit":single_payment_limit,
                                       "head_fund_limit":head_fund_limit,
                                       "head_name":head_name,]
        
        let urlString = APIEndPoints.add_expencess_head
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    completion(response, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
   //. json_for_society_details
    func json_for_society_details(society_id: String,building_id:String, completion: @escaping APIResponseBlock) {
        let urlString = APIEndPoints.json_for_society_details
        let parameters:[String:Any] = ["society_id":society_id,"building_id":building_id]
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 100 {
                    if building_id == "" {
                        let model = BuildingModel(apiSuccess.json)
                        completion(model, true, message)
                    } else {
                        let model = FlatModel(apiSuccess.json)
                        completion(model, true, message)
                    }
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }

    //3.http://miscos.in/vhss/vhss_json_new/UserApp/add_revenue_head.php
    func add_revenue_head(society_id:String,type_head:String,single_payment_limit:String,head_fund_limit:String,head_name:String,applied_on:String,applied_from:String,monthly_auto_applied:String,completion: @escaping APIResponseBlock) {
        
        let parameters:[String:Any] = ["society_id":society_id,
                                       "type_head":type_head,
                                       "single_payment_limit":single_payment_limit,
                                       "head_fund_limit":head_fund_limit,
                                       "head_name":head_name,
                                       "applied_on":applied_on,
                                       "monthly_auto_applied":monthly_auto_applied,
                                       "applied_from":applied_from
        ]
        
        let urlString = APIEndPoints.add_revenue_head
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    completion(response, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
    
    
    //4.http://miscos.in/vhss/vhss_json_new/UserApp/remove_head.php
    func remove_head(society_id:String,old_head_id:String,new_head_id:String,type:String,completion: @escaping APIResponseBlock) {
        
        let parameters:[String:Any] = ["society_id":society_id,
                                       "old_head_id":old_head_id,
                                       "new_head_id":new_head_id,
                                       "type":type,
        ]
        let urlString = APIEndPoints.remove_head
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    completion(response, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
    
    //5.http://miscos.in/vhss/vhss_json_new/UserApp/etch_party.php
    func fetch_all_party_head(society_id: String, completion: @escaping APIResponseBlock) {
        let urlString = APIEndPoints.fetch_party
        let parameters:[String:Any] = ["society_id":society_id]
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    let model = Party_Head_Model(apiSuccess.json)
                    completion(model, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
    
    //6.http://miscos.in/vhss/vhss_json_new/UserApp/fetch_party_transaction.php
    func fetch_all_transaction(society_id: String,party_id:String,urlString:String, completion: @escaping APIResponseBlock) {
       // let urlString = APIEndPoints.fetch_party_transaction
        let parameters:[String:Any] = ["society_id":society_id,"party_id":party_id]
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    let model = Party_Transaction_Model(apiSuccess.json)
                    completion(model, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
    /*
    society_id, party_id, transaction_done_by, head_id, head_name, amount, gst,gst_no
    */
    //7.http://miscos.in/vhss/vhss_json_new/UserApp/fetch_party_transaction.php
    func payPayment(society_id: String,party_id:String,transaction_done_by:String,head_id:String,head_name:String,gst:String,gst_no:String,amount:String, completion: @escaping APIResponseBlock) {
        let urlString = APIEndPoints.expenses_party_transaction_all
        let parameters:[String:Any] = ["society_id":society_id,
                                       "party_id":party_id,
                                       "transaction_done_by":transaction_done_by,
                                       "head_id":head_id,
                                       "head_name":head_name,
                                       "gst":gst,
                                       "gst_no":gst_no,
                                       "amount":amount
                                       ]
        
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    let model = Party_Transaction_Model(apiSuccess.json)
                    completion(model, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
    
     //8.http://miscos.in/vhss/vhss_json_new/UserApp/expenses_party_header_all.php
    func addExpenseParty(society_id: String,party_name:String,address:String,mobile_no:String,email:String,type:String,bank_account_no:String,IFSC_code:String,bank_name:String,contact_person:String,city:String,transaction_type:String,party_type:String, completion: @escaping APIResponseBlock) {
          let urlString = APIEndPoints.expenses_party_header_all
        let parameters:[String:Any] = ["society_id":society_id,
                                       "party_name":party_name,
                                       "address":address,
                                       "mobile_no":mobile_no,
                                       "email":email,
                                       "type":type,
                                       "bank_account_no":bank_account_no,
                                       "IFSC_code":IFSC_code,
                                       "bank_name":bank_name,
                                       "contact_person":contact_person,
                                       "city":city,
                                       "transaction_type":transaction_type,
                                       "party_type":party_type
                                       ]
        
          performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
              switch response {
              case .success(let apiSuccess):
                  let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                  let message = apiSuccess.json.getString(forKey: APIConstants.message)
                  if success == 101 {
                      let model = Party_Transaction_Model(apiSuccess.json)
                      completion(model, true, message)
                  } else {
                      completion(apiSuccess.json, false, message)
                  }
              case .failure(let apiError):
                  self.parseErrorResponse(apiError, completion: completion)
              }
          }
      }

    /*
     
   1.    UserApp/add_third_party_receivable_header_all.php

     Parameters: society_id, party_name, address, mobile_no, email, contact_person, city, transaction_type, party_type.

     */
    
    //9.http://miscos.in/vhss/vhss_json_new/UserApp/edit_expenses_party_header_all.php
    func UpdateExpenseParty(society_id: String,party_name:String,party_id:String,address:String,mobile_no:String,email:String,type:String,bank_account_no:String,IFSC_code:String,bank_name:String,contact_person:String,city:String,transaction_type:String,party_type:String, completion: @escaping APIResponseBlock) {
        let urlString = APIEndPoints.edit_expenses_party_header_all
      let parameters:[String:Any] = ["society_id":society_id,
                                     "party_name":party_name,
                                     "address":address,
                                     "party_id":party_id,
                                     "mobile_no":mobile_no,
                                     "email":email,
                                     "type":type,
                                     "bank_account_no":bank_account_no,
                                     "IFSC_code":IFSC_code,
                                     "bank_name":bank_name,
                                     "contact_person":contact_person,
                                     "city":city,
                                     "transaction_type":transaction_type,
                                     "party_type":party_type
                                     ]
          performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    let model = Party_Transaction_Model(apiSuccess.json)
                    completion(model, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
    
    //UserApp/remove_expenses_party_header_all.php
    //10.http://miscos.in/vhss/vhss_json_new/UserApp/edit_expenses_party_header_all.php
    func removeExpenseParty(society_id: String,party_id:String, completion: @escaping APIResponseBlock) {
        let urlString = APIEndPoints.remove_expenses_party_header_all
        let parameters:[String:Any] = ["society_id":society_id,
                                       "party_id":party_id
        ]
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    let model = Party_Transaction_Model(apiSuccess.json)
                    completion(model, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
       
    
    
    //Common for all whic is giving only message and satus in respone
    func postApiCalling(para:[String:Any],endPoint:String,completion: @escaping APIResponseBlock)  {
        let urlString = endPoint
        performPostOperation(endPoint: urlString,parameters: para) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    completion(response, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
    //
    //12.http://miscos.in/vhss/vhss_json_new/UserApp/fetch_third_party_receivable.php
    func fetch_third_party_receivable(society_id: String, completion: @escaping APIResponseBlock) {
        let urlString = APIEndPoints.fetch_third_party_receivable
        let parameters:[String:Any] = ["society_id":society_id]
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    let model = Party_Head_Model(apiSuccess.json)
                    completion(model, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
    
    
    //13.http://miscos.in/vhss/vhss_json_new/UserApp/add_third_party_receivable_header_all.php
    func addThirdParty(society_id: String,party_name:String,address:String,mobile_no:String,email:String,contact_person:String,city:String,transaction_type:String,party_type:String, completion: @escaping APIResponseBlock) {
        let urlString = APIEndPoints.add_third_party_receivable_header_all
        let parameters:[String:Any] = ["society_id":society_id,
                                       "party_name":party_name,
                                       "address":address,
                                       "mobile_no":mobile_no,
                                       "email":email,
                                       "contact_person":contact_person,
                                       "city":city,
                                       "transaction_type":transaction_type,
                                       "party_type":party_type
        ]
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    completion(nil, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }

  //1.    UserApp/edit_third_party_receivable.php
 // Parameters: society_id, recv_party_id, party_name, address, mobile_no, email, contact_person, city, transaction_type, party_type.
    //13.http://miscos.in/vhss/vhss_json_new/UserApp/edit_third_party_receivable.php
    func updateThirdParty(society_id: String,party_name:String,address:String,recv_party_id:String,mobile_no:String,email:String,contact_person:String,city:String,transaction_type:String,party_type:String, completion: @escaping APIResponseBlock) {
        let urlString = APIEndPoints.edit_third_party_receivable
        let parameters:[String:Any] = ["society_id":society_id,
                                       "party_name":party_name,
                                       "address":address,
                                       "recv_party_id":recv_party_id,
                                       "mobile_no":mobile_no,
                                       "email":email,
                                       "contact_person":contact_person,
                                       "city":city,
                                       "transaction_type":transaction_type,
                                       "party_type":party_type
        ]
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    completion(nil, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
    
    //14.http://miscos.in/vhss/vhss_json_new/UserApp/UserApp/third_party_transaction_all.php
    func payThirdPartyCollection(society_id: String,amount:String,head_id:String,head_name:String,party_id:String, completion: @escaping APIResponseBlock) {
        let urlString = APIEndPoints.third_party_transaction_all
        let parameters:[String:Any] = ["society_id":society_id,
                                       "party_id":party_id,
                                       "head_id":head_id,
                                       "head_name":head_name,
                                       "amount":amount
                                      ]
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    completion(nil, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
    
    
    /*
     1.
     Parameters: mode, society_id, building_id, flat_no, resident_id, from_month_and_year, to_month_and_year, head_id.
     */

     //15.http://miscos.in/vhss/vhss_json_new/UserApp/json_for_collection_status.php
    func collectionStatus(mode:String,society_id: String,building_id:String,flat_no:String,resident_id:String,from_month_and_year:String,party_id:String,to_month_and_year:String,head_id:String, completion: @escaping APIResponseBlock) {
        let urlString = APIEndPoints.third_party_transaction_all
        let parameters:[String:Any] = ["society_id":society_id,
                                       "party_id":party_id,
                                       "resident_id":resident_id,
                                       "from_month_and_year":from_month_and_year,
                                       "to_month_and_year":to_month_and_year,
                                       "amount":building_id,
                                       "head_id":head_id,
                                       "flat_no":flat_no,
                                       ]
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    completion(nil, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
    
    
    /*
     society_id:Fi_3733
     building_id:Ka_2217
     mode:pending
     flat_no:101
     type:B
     from_month_and_year:03-2020
     to_month_and_year:03-2021
     */
    //16.http://miscos.in/vhss/vhss_json_new/UserApp/json_for_get_resident_transaction_history.php
    func fetchAllAccountPendinglist(society_id: String,building_id:String,mode:String,from_month_and_year:String,type:String,to_month_and_year:String,flat_no:String, completion: @escaping APIResponseBlock) {
         let urlString = APIEndPoints.json_for_get_resident_transaction_history
        let parameters:[String:Any] = ["society_id":society_id,
                                       "building_id":building_id,
                                       "mode":mode,
                                       "from_month_and_year":from_month_and_year,
                                       "to_month_and_year":to_month_and_year,
                                       "flat_no":flat_no,
                                       "type":type]
         performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
             switch response {
             case .success(let apiSuccess):
                 let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                 let message = apiSuccess.json.getString(forKey: APIConstants.message)
                 if success == 100 {
                     let model = AccountPendingList(apiSuccess.json)
                     completion(model, true, message)
                 } else {
                     completion(apiSuccess.json, false, message)
                 }
             case .failure(let apiError):
                 self.parseErrorResponse(apiError, completion: completion)
             }
         }
     }
    
    //16.http://miscos.in/vhss/vhss_json_new/UserApp/UserApp/json_for_dues_payment.php
    func payPendingDues(para:[String:Any],image:UIImage,imageName:String,completion: @escaping APIResponseBlock)  {
        APIManagerWithImage.uploadImage(strUrl: APIEndPoints.json_for_dues_payment, para: para, image: image, imageName: imageName, showIndicator: true, succes: { (success,msg) in
            completion(nil,success,msg)
        }) { (error) in
            completion(nil,false,error.localizedDescription)
        }
    }
    
   //10.http://miscos.in/vhss/vhss_json_new/UserApp/edit_expenses_party_header_all.php
   func removeThirdParty(society_id: String,party_id:String, completion: @escaping APIResponseBlock) {
       let urlString = APIEndPoints.remove_third_party_receivable
       let parameters:[String:Any] = ["society_id":society_id,
                                      "recv_party_id":party_id
       ]
       performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
           switch response {
           case .success(let apiSuccess):
               let success = apiSuccess.json.getInt(forKey: APIConstants.success)
               let message = apiSuccess.json.getString(forKey: APIConstants.message)
               if success == 101 {
                   let model = Party_Transaction_Model(apiSuccess.json)
                   completion(model, true, message)
               } else {
                   completion(apiSuccess.json, false, message)
               }
           case .failure(let apiError):
               self.parseErrorResponse(apiError, completion: completion)
           }
       }
   }
    
    //16.http://miscos.in/vhss/vhss_json_new/UserApp/UserApp/json_for_dues_payment.php
    func onetimeResidentCollectionSave(
        society_id:String,
        building_id:String,
        flat_no:String,
        resident_id:String,
        amount:String,
        head_id:String,
        applied_date:String,
        collection_for:String,
        mode:String,
        already_paid:String,
        paid_amount:String,
        mode_of_payment:String,
        cheque_no:String,
        image:UIImage,
        imageName:String,
        completion: @escaping APIResponseBlock)  {
        let para:[String:Any] = [           "society_id":society_id,
                                             "building_id":building_id,
                                             "flat_no":flat_no,
                                             "resident_id":resident_id,
                                             "amount":amount,
                                             "head_id":head_id,
                                             "applied_date":applied_date,
                                             "collection_for":collection_for,
                                             "mode":mode,
                                             "already_paid":already_paid,
                                             "paid_amount":paid_amount,
                                             "mode_of_payment":mode_of_payment,
                                             "cheque_no":cheque_no]
        print("para is \(para) \n")
        APIManagerWithImage.uploadImage(strUrl: APIEndPoints.resident_pending_transaction_details_all, para: para, image: image, imageName: imageName, showIndicator: true, succes: { (success,msg) in
            completion(nil,success,msg)
        }) { (error) in
            completion(nil,false,error.localizedDescription)
        }
    }
    
    //21.UserApp/resident_pending_transaction_details_all.php one time
    func resident_pending_transaction_details_all(society_id: String,building_id:String,flat_no:String,resident_id:String,amount:String,head_id:String,applied_date:String,collection_for:String,mode:String,already_paid:String,paid_amount:String,mode_of_payment:String,cheque_no:String,transaction_receipt:String, completion: @escaping APIResponseBlock) {
        let urlString = APIEndPoints.resident_pending_transaction_details_all
        let parameters:[String:Any] = ["society_id":society_id,
                                       "building_id":building_id,
                                       "flat_no":flat_no,
                                       "resident_id":resident_id,
                                       "amount":amount,
                                       "head_id":head_id,
                                       "applied_date":applied_date,
                                       "collection_for":collection_for,
                                       "mode":mode,
                                       "already_paid":already_paid,
                                       "paid_amount":paid_amount,
                                       "mode_of_payment":mode,
                                       "cheque_no":cheque_no,
                                       "transaction_receipt":transaction_receipt]
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    //let model = Party_Transaction_Model(apiSuccess.json)
                    completion(response, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
    
    //Parameters: society_id, building_id, flat_no, resident_id, amount, head_id, applied_date, collection_for, mode, from_month, till_month, auto_applied – day selected(checked – Y, not  - N).
    
    
    //20.UserApp/resident_pending_transaction_details_all_Monthly
    func resident_pending_transaction_details_all_Monthly(society_id: String,building_id:String,flat_no:String,resident_id:String,amount:String,head_id:String,applied_date:String,collection_for:String,mode:String,from_month:String,till_month:String,auto_applied:String, completion: @escaping APIResponseBlock) {
        let urlString = APIEndPoints.resident_pending_transaction_details_all
        let parameters:[String:Any] = ["society_id":society_id,
                                       "building_id":building_id,
                                       "flat_no":flat_no,
                                       "resident_id":resident_id,
                                       "amount":amount,
                                       "head_id":head_id,
                                       "applied_date":applied_date,
                                       "collection_for":collection_for,
                                       "mode":mode,
                                       "from_month":from_month,
                                       "till_month":till_month,
                                       "auto_applied":auto_applied]
        performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
            switch response {
            case .success(let apiSuccess):
                let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                let message = apiSuccess.json.getString(forKey: APIConstants.message)
                if success == 101 {
                    //let model = Party_Transaction_Model(apiSuccess.json)
                    completion(response, true, message)
                } else {
                    completion(apiSuccess.json, false, message)
                }
            case .failure(let apiError):
                self.parseErrorResponse(apiError, completion: completion)
            }
        }
    }
    
   
    //24..UserApp/json_for_collection_status.php
      func json_for_collection_status(parameters:[String:Any], completion: @escaping APIResponseBlock) {
          let urlString = APIEndPoints.json_for_collection_status
          performPostOperation(endPoint: urlString,parameters: parameters) { (response) in
              switch response {
              case .success(let apiSuccess):
                  let success = apiSuccess.json.getInt(forKey: APIConstants.success)
                  let message = apiSuccess.json.getString(forKey: APIConstants.message)
                  if success == 100 {
                      let model = AccountPendingList(apiSuccess.json)
                      completion(model, true, message)
                  } else {
                      completion(apiSuccess.json, false, message)
                  }
              case .failure(let apiError):
                  self.parseErrorResponse(apiError, completion: completion)
              }
          }
      }
    
}

