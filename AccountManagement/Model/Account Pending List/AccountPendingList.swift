
/*
 pending_dues for pending
 paid_dues for paid
 payment_recieved for payment_recieved
 */
import Foundation
struct AccountPendingList  {
    let error_code : Int?
    let message : String?
    let flat_fund_amount : String?
    let arrOfAmount : [AccountList]
    
    var arrOfpending_dues:[AccountList]?
    var arrOfpayment_recievedDues:[AccountList]?
    var arrOfPaidDues:[AccountList]?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "error_code"
        case message = "message"
        case flat_fund_amount = "flat_fund_amount"
        case data = "data"
        case data1 = "data1"
        case data2 = "data2"
        case pending_dues = "pending_dues"
        case paid_dues = "paid_dues"
        case payment_received = "payment_received"
    }
    
    init(_ json:[String:Any]) {
        error_code = json.getInt(forKey: CodingKeys.error_code.rawValue)
        flat_fund_amount = json.getString(forKey: CodingKeys.flat_fund_amount.rawValue)
        message = json.getString(forKey: CodingKeys.message.rawValue)
        
        if let arr = json[CodingKeys.data.rawValue] as? [[String: Any]] {
            arrOfAmount = arr.map({ AccountList($0) })
        } else if let arr = json[CodingKeys.data1.rawValue] as? [[String: Any]]{
            arrOfAmount = arr.map({ AccountList($0) })
        }else if let arr = json[CodingKeys.data2.rawValue] as? [[String: Any]]{
            arrOfAmount = arr.map({ AccountList($0) })
        }else{
             arrOfAmount = [AccountList]()
        }
        
        //for Pending
        if let arr = json[CodingKeys.pending_dues.rawValue] as? [[String: Any]] {
            arrOfpending_dues = arr.map({ AccountList($0) })
        } else {
            arrOfpending_dues = [AccountList]()
        }
        
        //for payment_received
        if let arr = json[CodingKeys.payment_received.rawValue] as? [[String: Any]] {
            arrOfpayment_recievedDues = arr.map({ AccountList($0) })
        } else {
            arrOfpayment_recievedDues = [AccountList]()
        }
        
        //for paid_dues
        if let arr = json[CodingKeys.paid_dues.rawValue] as? [[String: Any]] {
            arrOfPaidDues = arr.map({ AccountList($0) })
        } else {
            arrOfPaidDues = [AccountList]()
        }
    }
}
