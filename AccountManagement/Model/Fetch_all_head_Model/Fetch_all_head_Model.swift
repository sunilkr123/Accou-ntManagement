
import Foundation

struct Fetch_all_head_Model {
    
    let message : String?
    let error_code : Int?
    let arrOfExpense_head : [Expense_head]
    let arrOfRevenue_head : [Revenue_head]
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case error_code = "error_code"
        case expense_head = "expense_head"
        case revenue_head = "revenue_head"
    }
    init(_ json:[String:Any]) {
        message = json.getString(forKey: CodingKeys.message.rawValue)
        error_code = json.getInt(forKey: CodingKeys.error_code.rawValue)
        if let arr = json[CodingKeys.expense_head.rawValue] as? [[String: Any]] {
            self.arrOfExpense_head = arr.map({ Expense_head($0) })
        } else {
            self.arrOfExpense_head = [Expense_head]()
        }
        if let arr = json[CodingKeys.revenue_head.rawValue] as? [[String: Any]] {
            self.arrOfRevenue_head = arr.map({ Revenue_head($0) })
        } else {
            self.arrOfRevenue_head = [Revenue_head]()
        }
    }
}
//Expense_head
struct Expense_head {
    let society_id : String?
    let head_name : String?
    let type_head : String?
    let head_id : String?
    let available_amount : String?
    let total_expenses_amount : String?
    let transferred_amount : String?
    let status : String?
    let created_on : String?
    let single_payment_limit : String?
    let head_fund_limit : String?
    var isSelected : Bool
    
    enum CodingKeys: String, CodingKey {
        
        case society_id = "society_id"
        case head_name = "head_name"
        case type_head = "type_head"
        case head_id = "head_id"
        case available_amount = "available_amount"
        case total_expenses_amount = "total_expenses_amount"
        case transferred_amount = "transferred_amount"
        case status = "status"
        case created_on = "created_on"
        case single_payment_limit = "single_payment_limit"
        case head_fund_limit = "head_fund_limit"
    }
    
    init(_ json:[String:Any]) {
        society_id = json.getString(forKey: CodingKeys.society_id.rawValue)
        head_name = json.getString(forKey: CodingKeys.head_name.rawValue)
        type_head = json.getString(forKey: CodingKeys.type_head.rawValue)
        head_id = json.getString(forKey: CodingKeys.head_id.rawValue)
        available_amount = json.getString(forKey: CodingKeys.available_amount.rawValue)
        total_expenses_amount = json.getString(forKey: CodingKeys.total_expenses_amount.rawValue)
        transferred_amount = json.getString(forKey: CodingKeys.transferred_amount.rawValue)
        status = json.getString(forKey: CodingKeys.status.rawValue)
        created_on = json.getString(forKey: CodingKeys.created_on.rawValue)
        single_payment_limit = json.getString(forKey: CodingKeys.single_payment_limit.rawValue)
        head_fund_limit = json.getString(forKey: CodingKeys.head_fund_limit.rawValue)
        isSelected = false
    }
}
//Revenue_head
struct Revenue_head  {
    let society_id : String?
    let head_name : String?
    let type_head : String?
    let applied_on : String?
    let head_id : String?
    let available_amount : String?
    let transaction_amount : String?
    let transfered_amount : String?
    let status : String?
    let created_on : String?
    let applied_from : String?
    let monthly_auto_applied : String?
    let auto_applied_date : String?
    let auto_applied_amount : String?
    let deactivated_on : String?
    let head_details : String?
    let single_transaction_limit : String?
    var isSelected : Bool
    
    enum CodingKeys: String, CodingKey {
        case society_id = "society_id"
        case head_name = "head_name"
        case type_head = "type_head"
        case applied_on = "applied_on"
        case head_id = "head_id"
        case available_amount = "available_amount"
        case transaction_amount = "transaction_amount"
        case transfered_amount = "transfered_amount"
        case status = "status"
        case created_on = "created_on"
        case applied_from = "applied_from"
        case monthly_auto_applied = "monthly_auto_applied"
        case auto_applied_date = "auto_applied_date"
        case auto_applied_amount = "auto_applied_amount"
        case deactivated_on = "deactivated_on"
        case head_details = "head_details"
        case single_transaction_limit = "single_transaction_limit"
    }
    init(_ json:[String:Any]) {
        society_id = json.getString(forKey: CodingKeys.society_id.rawValue)
        head_name = json.getString(forKey: CodingKeys.head_name.rawValue)
        type_head = json.getString(forKey: CodingKeys.type_head.rawValue)
        applied_on = json.getString(forKey: CodingKeys.applied_on.rawValue)
        head_id = json.getString(forKey: CodingKeys.head_id.rawValue)
        available_amount = json.getString(forKey: CodingKeys.available_amount.rawValue)
        transaction_amount = json.getString(forKey: CodingKeys.transaction_amount.rawValue)
        transfered_amount = json.getString(forKey: CodingKeys.transfered_amount.rawValue)
        status = json.getString(forKey: CodingKeys.status.rawValue)
        created_on = json.getString(forKey: CodingKeys.created_on.rawValue)
        applied_from = json.getString(forKey: CodingKeys.applied_from.rawValue)
        monthly_auto_applied = json.getString(forKey: CodingKeys.monthly_auto_applied.rawValue)
        auto_applied_date = json.getString(forKey: CodingKeys.auto_applied_date.rawValue)
        auto_applied_amount = json.getString(forKey: CodingKeys.auto_applied_amount.rawValue)
        deactivated_on = json.getString(forKey: CodingKeys.deactivated_on.rawValue)
        head_details = json.getString(forKey: CodingKeys.head_details.rawValue)
        single_transaction_limit = json.getString(forKey: CodingKeys.single_transaction_limit.rawValue)
        isSelected = false
    }
}


struct TransferDataModel {
    var society_id:String?
    var transfer_head_id:String?
    var reciever_head_id:String?
    var type:String?
    var amount:String?
    
    func toJosn() ->[String:Any] {
        return [
            "society_id":self.society_id ?? "",
            "transfer_head_id":self.transfer_head_id ?? "",
            "reciever_head_id":self.reciever_head_id ?? "",
            "mode":self.type ?? "",
            "amount":self.amount ?? ""
        ]
    }
}
