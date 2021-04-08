//
//  BaseInterface.swift
//  NetworkManagerDemo
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.

import UIKit

class BaseInterface: NSObject, APIManager {

    typealias APIResponseBlock = (Any?, Bool, String?) -> Void
    
    var osVersion: String {
        return UIDevice.current.systemVersion
    }
    
    func parseErrorResponse(_ apiError: APIError, completion: @escaping APIResponseBlock) {
        if let info = apiError.info {
            let message = self.getErrorMessage(from: info)
            completion(nil, false, message)
        } else {
            completion(nil, false, apiError.message)
        }
    }
    
    func getErrorMessage(from json: [String: Any]) -> String? {
        if let errors = json["errors"] as? [[String: Any]], let error = errors.first {
            return (error["message"] as? String) ?? (error["reason"] as? String)
        } else if let message = json["message"] as? String {
            return message
        } else if let error = json["error"] as? [String: Any], let errors = error["errors"] as? [[String: Any]], let dictError = errors.first {
            return (dictError["message"] as? String) ?? (dictError["reason"] as? String)
        }
        return nil
    }
    
}
