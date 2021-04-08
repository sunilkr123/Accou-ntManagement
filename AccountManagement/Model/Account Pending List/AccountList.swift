
import Foundation
struct AccountList  {
    let head_id : String?
    let head_name : String?
    var applied_date : String?
    var paid_by: String?
    var transaction_details: String?
    var transaction_type: String?
    let amount : String?
    let balance_amount : String?
    let type : String?
    let date_time: String?
    var isSelected = false

	enum CodingKeys: String, CodingKey {

		case head_id = "head_id"
		case head_name = "head_name"
		case applied_date = "applied_date"
        case date_time = "date_time"
		case amount = "amount"
        case balance_amount = "balance_amount"
		case type = "type"
        case paid_by = "paid_by"
        case transaction_details = "transaction_details"
         case transaction_type = "transaction_type"
        
	}
    init(_ json:[String:Any]) {
        head_id = json.getString(forKey: CodingKeys.head_id.rawValue)
        head_name = json.getString(forKey: CodingKeys.head_name.rawValue)
        applied_date = json.getString(forKey: CodingKeys.applied_date.rawValue)
        date_time = json.getString(forKey: CodingKeys.date_time.rawValue)
        paid_by  = json.getString(forKey: CodingKeys.paid_by.rawValue)
        transaction_details  = json.getString(forKey: CodingKeys.transaction_details.rawValue)
        transaction_type  = json.getString(forKey: CodingKeys.transaction_type.rawValue)
        amount = json.getString(forKey: CodingKeys.amount.rawValue)
        balance_amount = json.getString(forKey: CodingKeys.balance_amount.rawValue)
        type = json.getString(forKey: CodingKeys.type.rawValue)
    }

}
