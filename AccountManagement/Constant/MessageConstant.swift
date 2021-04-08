//
//  File.swift
//  NewProjectOffice
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Jugal Shaktawat. All rights reserved.
//

import Foundation

/*----------Enum for the Messages & for the Validations.*/
public enum MessagesEnum : String {
    
    
    //Cases Here-
    case Email = "Please enter an email."
    case ValidEmail = "Please enter a valid email."
    case Password = "Please enter password"
    case Default = "Validation Done Very Well 👌 Superbbb 👍 Go ahead"
    case ExpenseHeadmessge = "Please enter head name"
    case ExpenseType = "Please select type"
    case transactionLimit = "Please enter transaction limit"
    case fundLimitMessage = "Please enter head fund limit"
    case applicableOnMessage = "Please select applicable on"
    case autoAplliedDateMessage = "Please enter date "
    case EnterAmount = "Enter Amount"
    case SelectRevenueHead = "Please Select sender Head"
    case SelectExpenseHead = "Please Select reciver Head"
    case CNFAmount = "Please enter confirm amount"
    //
    case PayingAmount = "Please enter paying amount"
    case ChequeNo = "Please enter cheque number."
    case SelectBuilding = "Please select building"
    case SelectFlatNumber = "Please select flat number"
    case SelectHead = "Please select a head"
    case SameAmount = "Amount and confirmed amount should be same"
    case GStSlabEmptyMessage = "Please select GST Slab"
    case gstEmptyMessage = "Please enter gst number"
    
    //to add expense party
    case partySelectMessage = "Please selct party"
    case headEmptyMessage = "Please select head"
    case expensePartyAmount = "Please enter amount"
    
    case confirmAmountMessage = "Please enter confirm amount "
    case amountNotMatchMessage =  "Amounts does not match"
    case accountNumberEmptyMessage = "Please enter account number"
    case confirmAccountNumberMessage = "Please enter confirm account number"
     case validAccountNumber = "Please enter valid account number"
    case accountDoesNotMatch = "Acount number does not match"
    case ifscCodeMEssage = "Please enter IFSC Code"
     case validIfscCode = "Please enter valid IFSC Code"
    case TypeMEssage = "Please select Type"
    case emptyNameMEssage = "Please enter name"
    case contactPersonMessage = "Please enter contact person"
    case mobileNumber = "Please enter mobile number"
    case mobileNumberValidate = "Mobile number cannot be less than 10 digits"
    case validEmailMessage = "Please enter valid email"
    case addressMessage = "Please enter address"
    case bankNameMessage = "Please enter bank name"
    case FromMonthAndYear = "Please select from month and year"
    case TillMonthAndYear = "Please select till month and year"
    case GstValidateMessage = "Please enter valid GST Number"
    case PaymentValidation = "Add lower amount or select different head"
    case cityEmptyMessage = "Please enter city name"
    //)
    
}


