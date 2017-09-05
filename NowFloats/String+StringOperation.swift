//
//  String+StringOperation.swift
//  Lefoodie
//
//  Created by apple on 29/12/16.
//  Copyright © 2016 ongo. All rights reserved.
//

import UIKit

extension String{
    
   static func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    func replace(target:String,withString:String) -> String {
      return  self.replacingOccurrences(of: target, with: withString, options: .literal, range: nil)
    }
    
   static func generateBoundaryString() -> String
    {
        return "\(UUID().uuidString)"
    }
    
    static func genarateJsonStringWithList(dataDic:NSDictionary)->String{
        let listArray : NSMutableArray = NSMutableArray()
        listArray.add(dataDic)
        let formDict :NSMutableDictionary = NSMutableDictionary()
        formDict.setObject(listArray, forKey: "list" as NSCopying)
        var jsonData : Data = Data()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: formDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            CXLog.print(error)
        }
        let jsonStringFormat = String(data: jsonData, encoding: String.Encoding.utf8)
        return jsonStringFormat!
    }
    
   static func genarateJsonString(dataDic:NSDictionary)->String{
        //let listArray : NSMutableArray = NSMutableArray()
        //listArray.add(dataDic)
        //let formDict :NSMutableDictionary = NSMutableDictionary()
        //formDict.setObject(listArray, forKey: "list" as NSCopying)
        var jsonData : Data = Data()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dataDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            CXLog.print(error)
        }
        let jsonStringFormat = String(data: jsonData, encoding: String.Encoding.utf8)
        return jsonStringFormat!
    }
    
    func timeAgoSinceDate(numericDates:Bool) -> String {
        let dateStr = self
        
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MMM d',' yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let dateF = dateFormatter.date(from: dateStr)
        
        // change to a readable time format and change to local time zone
        dateFormatter.timeZone = NSTimeZone.local
        
        if let dateStr = dateF {
        let dateFinal = dateFormatter.string(from: dateStr)

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm MMM d',' yyyy"
        let date = formatter.date(from: dateFinal)

        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date!)
        let latest = (earliest == now as Date) ? date : now as Date
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest! as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "Few seconds ago"
            } else {
                return "Few seconds ago"
            }
        } else if (components.second! >= 3) {
            return "Just now"
        } else {
            return "Just now"
        }
        }
        return ""
    }
    
    public static func construcThetagString(array:NSMutableArray,isAddTag:Bool) ->String{
        //# tagString
        var hasTagString = ""
        for tagName in array {
            if let str = tagName as? String {
                if  isAddTag {
                    hasTagString.append(str)
                    hasTagString.append("|")
                }else {
                    hasTagString.append((str.replacingOccurrences(of: "#", with: "")))
                    hasTagString.append("|")
                }
            }
        }
        if hasTagString.characters.count != 0 {
            hasTagString.remove(at: hasTagString.index(before: hasTagString.endIndex))
        }
        return hasTagString
    }
    
    public static func construcTheAtString(array:NSMutableArray) ->String{
        //# tagString
        var atString = ""
        for (index,tagName) in array.enumerated() {
            if let str = tagName as? String {
                atString.append((str.replacingOccurrences(of: "@", with: "")))
                if index != array.count {
                    atString.append("|")
                }
            }
        }
        CXLog.print(atString)
        return atString
    }
    
     public static func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
        //let fontSize = UIFont.systemFontSize
        //        NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)
        
        let attrs = [
            NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.white
        ]
        let nonBoldAttribute = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12),
            ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
    }
    
// TypeName+NewFunctionality.swift.
}

//as! as? is


