//
//  Constant.swift
//  ObhaiyaConsumer
//
//  Created by Sunil Kumar on 01/06/20.
//  Copyright © 2020 Honey. All rights reserved.
//

import Foundation
import UIKit

/// **AppStoryboard** : This Enum use for handle multiple storyboard ** AppStoryboard **.
enum AppStoryboard : String {
    case Main =   "Main"
    
    var  instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

class Constant {
    static var isDebugingEnabled: Bool {
        return true
    }
    static let dateFormate = "MM/yyyy"
    static let dateFormate2 = "MM-yyyy"
    static let dateFormate4 = "yyyy-MM"
    static let dayFormate = "dd"
    static let dateFormate3 = "dd-MM-yyyy"
    static let Soiaty_Id = "Fi_3733"
    static let rzp_test_Key = "rzp_test_QgpHURcaT37pI7"
}
struct Device {
    static let udid = UIDevice.current.identifierForVendor?.uuidString ?? ""
}


