//
//  APIEndPoints.swift
//  NetworkManagerDemo
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.
import Foundation

struct APIEndPoints {
    
    static let baseUrl = "http://miscos.in/vhss/vhss_json_new/" // BAseURL
    
    //API's
    static let add_revenue_head = "\(baseUrl)UserApp/add_revenue_head.php" //1
    static let add_expencess_head = "\(baseUrl)UserApp/add_expencess_head.php" //2
    static let fetch_all_head = "\(baseUrl)UserApp/fetch_all_head.php" //3
    static let edit_revenue_expense = "\(baseUrl)UserApp/edit_revenue_expense.php" //4
    static let remove_head = "\(baseUrl)UserApp/remove_head.php" //5
    static let transfer_amount = "\(baseUrl)UserApp/transfer_amount.php" //6
    static let expenses_party_header_all = "\(baseUrl)UserApp/expenses_party_header_all.php" //7
    static let edit_expenses_party_header_all = "\(baseUrl)UserApp/edit_expenses_party_header_all.php" //8
    static let fetch_party = "\(baseUrl)UserApp/fetch_party.php" //9
    static let expenses_party_transaction_all = "\(baseUrl)UserApp/expenses_party_transaction_all.php" //10
    static let fetch_party_transaction = "\(baseUrl)UserApp/fetch_party_transaction.php" //11
    static let remove_expenses_party_header_all = "\(baseUrl)UserApp/remove_expenses_party_header_all.php" //12
    static let json_for_society_details = "\(baseUrl)GuardApp/json_for_society_details.php" //13
    static let add_third_party_receivable_header_all = "\(baseUrl)UserApp/add_third_party_receivable_header_all.php" //14
    static let fetch_third_party_receivable = "\(baseUrl)UserApp/fetch_third_party_receivable.php" //15
    static let edit_third_party_receivable = "\(baseUrl)UserApp/edit_third_party_receivable.php" //16
    static let remove_third_party_receivable = "\(baseUrl)UserApp/remove_third_party_receivable.php" //17
    static let third_party_transaction_all = "\(baseUrl)UserApp/third_party_transaction_all.php" //18
    static let fetch_third_party_transaction_all = "\(baseUrl)UserApp/fetch_third_party_transaction_all.php" //19
    static let resident_pending_transaction_details_all = "\(baseUrl)UserApp/resident_pending_transaction_details_all.php" //20
    //static let resident_pending_transaction_details_all = "\(baseUrl)UserApp/resident_pending_transaction_details_all.php " //21
    static let json_for_get_resident_transaction_history = "\(baseUrl)UserApp/json_for_get_resident_transaction_history.php" //12
    static let json_for_dues_payment = "\(baseUrl)UserApp/json_for_dues_payment.php" //23
    static let json_for_collection_status = "\(baseUrl)UserApp/json_for_collection_status.php" //24
    
    
}
