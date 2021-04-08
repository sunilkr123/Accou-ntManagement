
import Foundation
struct Party_Transaction_Model  {
	let message : String?
	let error_code : Int?
	let arrOfTransactions : [TransactionModel]?

	enum CodingKeys: String, CodingKey {

		case message = "message"
		case error_code = "error_code"
		case party_head = "party_head"
	}

    init(_ json:[String:Any]) {
        message = json.getString(forKey: CodingKeys.message.rawValue)
        error_code = json.getInt(forKey: CodingKeys.error_code.rawValue)
        if let arr = json[CodingKeys.party_head.rawValue] as? [[String: Any]] {
            self.arrOfTransactions = arr.map({ TransactionModel($0) })
        } else {
            self.arrOfTransactions = []
        }
    }
    
}

struct TransactionModel  {
    let society_id : String?
    let party_id : String?
    let transaction_done_by : String?
    let head_id : String?
    let head_name : String?
    let amount : String?
    let transfer_date_time : String?
    let gst : String?
    let gst_no : String?
    let string7 : String?

    enum CodingKeys: String, CodingKey {
        case society_id = "society_id"
        case party_id = "party_id"
        case transaction_done_by = "transaction_done_by"
        case head_id = "head_id"
        case head_name = "head_name"
        case amount = "amount"
        case transfer_date_time = "transfer_date_time"
        case gst = "gst"
        case gst_no = "gst_no"
        case string7 = "string7"
    }

   init(_ json:[String:Any]) {
        society_id = json.getString(forKey: CodingKeys.society_id.rawValue)
        party_id = json.getString(forKey: CodingKeys.party_id.rawValue)
        transaction_done_by = json.getString(forKey: CodingKeys.transaction_done_by.rawValue)
        head_id = json.getString(forKey: CodingKeys.head_id.rawValue)
        head_name = json.getString(forKey: CodingKeys.head_name.rawValue)
        amount = json.getString(forKey: CodingKeys.amount.rawValue)
        transfer_date_time = json.getString(forKey: CodingKeys.transfer_date_time.rawValue)
        gst = json.getString(forKey: CodingKeys.gst.rawValue)
        string7 = json.getString(forKey: CodingKeys.string7.rawValue)
        gst_no = json.getString(forKey: CodingKeys.gst_no.rawValue)
    }
    

}
