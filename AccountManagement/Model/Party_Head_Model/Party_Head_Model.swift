

import Foundation
struct Party_Head_Model {
	let message : String?
	let error_code : Int?
	let arrOfparty_head : [Party_head]

	enum CodingKeys: String, CodingKey {

		case message = "message"
		case error_code = "error_code"
		case party_head = "party_head"
	}

	init(_ json:[String:Any]) {
        message = json.getString(forKey: CodingKeys.message.rawValue)
		error_code = json.getInt(forKey: CodingKeys.error_code.rawValue)
        if let arr = json[CodingKeys.party_head.rawValue] as? [[String: Any]] {
            self.arrOfparty_head = arr.map({ Party_head($0) })
        } else {
            self.arrOfparty_head = [Party_head]()
        }
	}
}

struct Party_head  {
    var id : String?
    var society_id : String?
    var party_name : String?
    var party_id : String?
    var contact_person : String?
    var address : String?
    var city : String?
    var mobile_no : String?
    var email : String?
    var type : String?
    var recv_party_id : String?
    var creation_date_time : String?
    var bank_account_no : String?
    var iFSC_code : String?
    var bank_name : String?
    var transaction_type : String?
    var party_type : String?
    var status : String?

  enum CodingKeys: String, CodingKey {
      case id = "id"
      case society_id = "society_id"
      case party_name = "party_name"
      case party_id = "party_id"
      case contact_person = "contact_person"
      case address = "address"
      case city = "city"
      case mobile_no = "mobile_no"
      case email = "email"
      case type = "type"
      case recv_party_id = "recv_party_id"
      case creation_date_time = "creation_date_time"
      case bank_account_no = "bank_account_no"
      case iFSC_code = "IFSC_code"
      case bank_name = "bank_name"
      case transaction_type = "transaction_type"
      case party_type = "party_type"
      case status = "status"
  }
    
    init(_ json:[String:Any]) {
        id = json.getString(forKey: CodingKeys.id.rawValue)
        society_id = json.getString(forKey: CodingKeys.society_id.rawValue)
        party_name = json.getString(forKey: CodingKeys.party_name.rawValue)
        party_id = json.getString(forKey: CodingKeys.party_id.rawValue)
        contact_person = json.getString(forKey: CodingKeys.contact_person.rawValue)
        address = json.getString(forKey: CodingKeys.address.rawValue)
        city = json.getString(forKey: CodingKeys.city.rawValue)
        mobile_no = json.getString(forKey: CodingKeys.mobile_no.rawValue)
        status = json.getString(forKey: CodingKeys.status.rawValue)
        email = json.getString(forKey: CodingKeys.email.rawValue)
        type = json.getString(forKey: CodingKeys.type.rawValue)
        recv_party_id = json.getString(forKey: CodingKeys.recv_party_id.rawValue)
        creation_date_time = json.getString(forKey: CodingKeys.creation_date_time.rawValue)
        bank_account_no = json.getString(forKey: CodingKeys.bank_account_no.rawValue)
        iFSC_code = json.getString(forKey: CodingKeys.iFSC_code.rawValue)
        bank_name = json.getString(forKey: CodingKeys.bank_name.rawValue)
        transaction_type = json.getString(forKey: CodingKeys.transaction_type.rawValue)
        party_type = json.getString(forKey: CodingKeys.party_type.rawValue)
        status = json.getString(forKey: CodingKeys.status.rawValue)
     
    }
    
}
