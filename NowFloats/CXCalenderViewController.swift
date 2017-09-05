//
//  CXCalenderViewController.swift
//  NowFloats
//
//  Created by Manishi on 9/1/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit
import EventKit

class CXCalenderViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var calendarTblView: UITableView!
    var calenderArr:NSArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        getCalendarEvents()
    }
    
    func getCalendarEvents(){
        CXAppDataManager.sharedInstance.getCalanderEvents { (responseArr) in
            print(responseArr)
            self.calenderArr = responseArr
            self.calendarTblView.reloadData()
            //startDate  endDate  Name
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calenderArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderCell")!
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.masksToBounds = true
        cell.backgroundView?.backgroundColor = UIColor.clear
        
        cell.contentView.backgroundColor = UIColor.clear
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 5, height: 75))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)

        let updateDic : NSDictionary = self.calenderArr[indexPath.row] as! NSDictionary
        cell.selectionStyle = .none
        
        cell.textLabel?.text = updateDic.value(forKey: "Name") as? String

        let start = (updateDic.value(forKey: "startDate")! as! String).replace(target: " 00:00:00 GMT+0000", withString: "")
        let end = (updateDic.value(forKey: "endDate")! as! String).replace(target: " 00:00:00 GMT+0000", withString: "")

        cell.detailTextLabel?.text = "\(start) - \(end)"

        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 75
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return CGFloat(10)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let updateDic : NSDictionary = self.calenderArr[indexPath.row] as! NSDictionary
        
        let start = (updateDic.value(forKey: "startDate")! as! String).replace(target: " 00:00:00 GMT+0000", withString: "")
        let end = (updateDic.value(forKey: "endDate")! as! String).replace(target: " 00:00:00 GMT+0000", withString: "")
        
        self.addEventToCalendar(title:(updateDic.value(forKey: "Name") as? String)!, description: "", startDate: self.stringToDate(dateString: start), endDate: self.stringToDate(dateString: end))
    }

    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            }else{
                completion?(false, error as NSError?)
            }
        })
    }
    
    func stringToDate(dateString:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter.date(from: "Mon Sep 04 2017 00:00:00 GMT+0000") //according to date format your date string
        print(date ?? "") //Convert String to Date
        return date!
    }
}
