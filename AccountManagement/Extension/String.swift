//
//  StringExtension.swift
//  SlideMenuControllerSwift
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.
import Foundation
import UIKit
extension String {
    
    func isValidGSTIN() -> Bool{
        var uniScalars = [Int]();for (index, item) in (self.dropLast().unicodeScalars).enumerated(){ let alpha = Int((48...57 ~= item.value) ?(item.value - 48) : (item.value - 55));let beta = (((index + 1) % 2 == 0) ?2 : 1);  uniScalars.append((alpha * beta < 36) ? alpha * beta : 1 + ( alpha * beta - 36))};let gamma = (uniScalars.reduce(0, +) % 36);return ((self.dropLast() + "\((Character(UnicodeScalar((0...9 ~= (36 - gamma)+48) ?(36 - gamma) : (36 - gamma)+55)!)))") == self ) ? true : false
        
    }
    
    func validatePhoneNumber(value: String) -> Bool {
        let PHONE_REGEX = "^[0-9]{10,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func isValidUserName(value: String) -> Bool {
        let PHONE_REGEX = "^(?=.*[A-Za-z])[d\\A-Za-z\\d]{1,}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func isPwdLenth(password: String , confirmPassword : String) -> Bool {
        if password.count <= 8 && confirmPassword.count <= 8{
            return true
        }else{
            return false
        }
    }
    func isPasswordSame(password: String , confirmPassword : String) -> Bool {
        if password == confirmPassword{
            return true
        }else{
            return false
        }
    }
    func isVailidUserName(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{4,}$")
        return passwordTest.evaluate(with: password)
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,15}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    func isValodGstNumber() -> Bool {
        let isValidGSTRegex = "/^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$/"
        return NSPredicate(format: "SELF MATCHES %@", isValidGSTRegex).evaluate(with: self)
    }
    
    var encodeEmoji: String? {
        let encodedStr = NSString(cString: self.cString(using: String.Encoding.nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue)
        return encodedStr as String?
    }
    
    var decodeEmoji: String? {
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if decodedStr != nil{
            return decodedStr as String?
        }
        return self
    }
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.index(self.startIndex, offsetBy: from))
    }
    
    
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    
    var length: Int {
        return self.count
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    func toLocalTimeZone( from:String, toFormat:String)->String{
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = from
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX") as Locale?
        let date = dateFormatter.date(from: self)// create date from string
        // change to a readable time format and change to local time zone
        
        if date == nil{
            return ""
            
        }
        
        dateFormatter.dateFormat = toFormat
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date!)
        
        return timeStamp
        // return dateFormatter.date(from: timeStamp)! as NSDate
    }
    
    func encodeUrl() -> String
    {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    func decodeUrl() -> String
    {
        return self.removingPercentEncoding!
    }
    func parseUserTagForPost(regexString:String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regexString)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func substring(fromPosition: UInt, toPosition: UInt) -> String? {
        guard fromPosition <= toPosition else {
            return nil
        }
        
        guard toPosition < UInt(self.count) else {
            return nil
        }
        
        let start = index(startIndex, offsetBy: String.IndexDistance(fromPosition))
        let end   = index(startIndex, offsetBy: String.IndexDistance(toPosition) + 1)
        let range = start..<end
        
        return substring(with: range)
    }
    
    static func random(length: Int = 5) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    func heightWithConstraintWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
