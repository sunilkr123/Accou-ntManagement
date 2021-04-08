//
//  Date.swift
//  Zygote
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.
import Foundation

final class SharedData {
    
    //MARK: Shared Instance
    static let objSharedInstance: SharedData = SharedData()
    
    class func getCurrentTImeOffset()->Int{
        let floattime = NSTimeZone.system.secondsFromGMT()
        return  Int(floattime) * 1000
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date())
        // or use capitalized(with: locale) if you want
    }
    
    class func getStringFromDateWithDataFormatterTime(date:String,dateFormatter:DateFormatter)->Date{
        dateFormatter.dateFormat = "HH:mm"
        //   dateFormatter.timeZone =  NSTimeZone.local
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateObj = dateFormatter.date(from: date)
        let dateObj1 = dateFormatter.string(from: dateObj!)
        let dateObj2 = dateFormatter.date(from: dateObj1)
        // print("post data=",dateObj)
        return dateObj2!
    }
    
    
    class func getStringFromDateWithDataFormatter(date:Date,dateFormatter:DateFormatter)->String{
        
        // dateFormatter.dateFormat = "dd MM yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "UTC")
        let dateObj = dateFormatter.string(from: date )
        // print("post data=",dateObj)
        return dateObj
        
    }
    
    class func getStringFromDateWithDataFormatterreturnDate(date:String,dateFormatter:DateFormatter)->Date{
        dateFormatter.dateFormat = "dd MMM yyyy"
        // dateFormatter.timeZone =  NSTimeZone.ut
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let dateObj = dateFormatter.date(from: date)
        let dateObj1 = dateFormatter.string(from: dateObj!)
        let dateObj2 = dateFormatter.date(from: dateObj1)
        // print("post data=",dateObj)
        return dateObj2!
    }
    
    class func getStringFromDateWithDataFormatterreturnTime(dateFormatter: DateFormatter,date:String)-> Date {
        
        // dateFormatter.timeZone =  NSTimeZone.ut
        dateFormatter.dateFormat = "yyyy-MM-ddThh:mm ss"
        //    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateObj1 = dateFormatter.date(from: date)!
        
        return  dateObj1
    }
    
    class func getStringFromDate(date: Date, dateFormatterString: String)-> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatterString//"MMMM dd, yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateObj = dateFormatter.string(from: date)
        return  dateObj
        
    }
    
    class func getStringFromString(strDate:String, formatString:String, withFormatString:String)-> String{
        
        //  print("getStringFromString",strDate)
        if strDate.count<=0{
            return ""
        }else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = formatString
            //dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
            
            let dateObj = dateFormatter.date(from: strDate)
            //print(dateObj)
            if dateObj == nil {
                return ""
            }else{
                dateFormatter.dateFormat = withFormatString
                
                return self.getStringFromDateWithDataFormatter(date: dateObj! , dateFormatter: dateFormatter)
            }
        }
        
    }
    class func timeSinceDate(fromDate: Date) -> String {
        let earliest = Date() < fromDate ?  Date()  : fromDate
        let latest = (earliest ==  Date()) ? fromDate :  Date()
        
        let components:DateComponents = Calendar.current.dateComponents([.day,.weekOfYear,.month,.year], from: earliest, to: latest)
        let year = components.year  ?? 0
        let month = components.month  ?? 0
        let week = components.weekOfYear  ?? 0
        let day = components.day ?? 0
        
        if year >= 2{
            return "\(year) years ago"
        }else if (year >= 1){
            return "1 year ago"
        }else if (month >= 2) {
            return "\(month) months ago"
        }else if (month >= 1) {
            return "1 month ago"
        }else  if (week >= 2) {
            return "\(week) weeks ago"
        } else if (week >= 1){
            return "1 week ago"
        } else if (day >= 2) {
            return "\(day) days ago"
        } else if (day >= 1){
            return "1 day ago"
        } else {
            return "Today"
        }
        
    }
    
    
    class func getStringFromStringWithoutUTC(strDate:String, formatString:String, withFormatString:String)-> String{
        //  print("getStringFromString",strDate)
        if strDate.count<=0{
            return ""
        }else {
            return strDate.UTCToLocal(incomingFormat: formatString, outGoingFormat: withFormatString)
        }
        //        //  print("getStringFromString",strDate)
        //        if strDate.count<=0{
        //            return ""
        //        }else {
        //            let dateFormatter = DateFormatter()
        //            dateFormatter.dateFormat = formatString
        //            //dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        //            let dateObj = dateFormatter.date(from: strDate)
        //            //print(dateObj)
        //            if dateObj == nil {
        //                return ""
        //            }else{
        //                dateFormatter.dateFormat = withFormatString
        //
        //                return self.getStringFromDateWithDataFormatter(date: dateObj! , dateFormatter: dateFormatter)
        //            }
        //        }
        
    }
    
}

extension String {
    
    var currentMonth: String {
        return "\(Calendar.current.component(.month, from: Date()))"
    }
    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from:  Date())
    }
    //MARK:- Convert UTC To Local Date by passing date formats value
    func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = outGoingFormat
        
        return dateFormatter.string(from: dt ?? Date())
    }
    
    
    //MARK:- Convert Local To UTC Date by passing date formats value
    func localToUTC(incomingFormat: String, outGoingFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        let dt = dateFormatter.date(from: self)
        // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = outGoingFormat
        return dateFormatter.string(from: dt ?? Date())
    }
}

extension Date {
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
}
