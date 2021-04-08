
import Foundation

struct BuildingModel {
    
    let error_code : Int?
    let message : String?
    let arrOfBuidings : [Buildings]
    let arrResident_data : [Resident_data]
    enum CodingKeys: String, CodingKey {
        case error_code = "error_code"
        case message = "message"
        case data = "data"
        case resident_data = "resident_data"
    }
    init(_ json:[String:Any]) {
        error_code = json.getInt(forKey: CodingKeys.error_code.rawValue)
        message = json.getString(forKey: CodingKeys.message.rawValue)
        if let arr = json[CodingKeys.data.rawValue] as? [[String: Any]] {
            arrOfBuidings = arr.map({ Buildings($0) })
        } else {
            arrOfBuidings = [Buildings]()
        }
        if let arr = json[CodingKeys.resident_data.rawValue] as? [[String: Any]] {
            arrResident_data = arr.map({ Resident_data($0) })
        } else {
            arrResident_data = [Resident_data]()
        }
    }
}

struct Buildings  {
    let society_id : String?
    let society_name : String?
    let society_logo : String?
    let building_id : String?
    let building_name : String?
    let building_type : String?
    let resident_id : String?
    let resident_name : String?
    let resident_mobile : String?
    let building_number : String?
    let resident_floor_no : String?
    let resident_flat_no : String?
    let resident_type : String?
    let resident_status : String?
    let resident_priority : String?
    let resident_flat_dnd_status : String?
    
    enum CodingKeys: String, CodingKey {
        case society_id = "society_id"
        case society_name = "society_name"
        case society_logo = "society_logo"
        case building_id = "building_id"
        case building_name = "building_name"
        case building_type = "building_type"
        case resident_id = "resident_id"
        case resident_name = "resident_name"
        case resident_mobile = "resident_mobile"
        case building_number = "building_number"
        case resident_floor_no = "resident_floor_no"
        case resident_flat_no = "resident_flat_no"
        case resident_type = "resident_type"
        case resident_status = "resident_status"
        case resident_priority = "resident_priority"
        case resident_flat_dnd_status = "resident_flat_dnd_status"
    }
    init(_ json:[String:Any]) {
        society_id = json.getString(forKey: CodingKeys.society_id.rawValue)
        society_name = json.getString(forKey: CodingKeys.society_name.rawValue)
        society_logo = json.getString(forKey: CodingKeys.society_logo.rawValue)
        building_id = json.getString(forKey: CodingKeys.building_id.rawValue)
        building_name = json.getString(forKey: CodingKeys.building_name.rawValue)
        building_type = json.getString(forKey: CodingKeys.building_type.rawValue)
        resident_id = json.getString(forKey: CodingKeys.resident_id.rawValue)
        resident_name = json.getString(forKey: CodingKeys.resident_name.rawValue)
        resident_mobile = json.getString(forKey: CodingKeys.resident_mobile.rawValue)
        building_number = json.getString(forKey: CodingKeys.building_number.rawValue)
        resident_floor_no = json.getString(forKey: CodingKeys.resident_floor_no.rawValue)
        resident_flat_no = json.getString(forKey: CodingKeys.resident_flat_no.rawValue)
        resident_type = json.getString(forKey: CodingKeys.resident_type.rawValue)
        resident_status = json.getString(forKey: CodingKeys.resident_status.rawValue)
        resident_priority = json.getString(forKey: CodingKeys.resident_priority.rawValue)
        resident_flat_dnd_status = json.getString(forKey: CodingKeys.resident_flat_dnd_status.rawValue)
    }
}


struct FlatModel {
    
    let error_code : Int?
    let message : String?
    let arrOfBuidings : [Buildings]
    let arrResident_data : [Resident_data]
    enum CodingKeys: String, CodingKey {
        case error_code = "error_code"
        case message = "message"
        case data = "data"
        case resident_data = "resident_data"
    }
    init(_ json:[String:Any]) {
        error_code = json.getInt(forKey: CodingKeys.error_code.rawValue)
        message = json.getString(forKey: CodingKeys.message.rawValue)
        if let arr = json[CodingKeys.data.rawValue] as? [[String: Any]] {
            arrOfBuidings = arr.map({ Buildings($0) })
        } else {
            arrOfBuidings = [Buildings]()
        }
        if let arr = json[CodingKeys.resident_data.rawValue] as? [[String: Any]] {
            arrResident_data = arr.map({ Resident_data($0) })
        } else {
            arrResident_data = [Resident_data]()
        }
    }
}
struct Resident_data {
    let resident_id : String?
    let resident_name : String?
    let resident_mobile : String?
    let resident_floor_no : String?
    let resident_flat_no : String?
    enum CodingKeys: String, CodingKey {
        case resident_id = "resident_id"
        case resident_name = "resident_name"
        case resident_mobile = "resident_mobile"
        case resident_floor_no = "resident_floor_no"
        case resident_flat_no = "resident_flat_no"
    }
    init(_ json:[String:Any]) {
        resident_id = json.getString(forKey: CodingKeys.resident_id.rawValue)
        resident_name = json.getString(forKey: CodingKeys.resident_name.rawValue)
        resident_mobile = json.getString(forKey: CodingKeys.resident_mobile.rawValue)
        resident_floor_no = json.getString(forKey: CodingKeys.resident_floor_no.rawValue)
        resident_flat_no = json.getString(forKey: CodingKeys.resident_flat_no.rawValue)
    }
}
