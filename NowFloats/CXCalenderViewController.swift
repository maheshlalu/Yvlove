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
    var updateDict:NSDictionary = NSDictionary()

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
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 75))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: 0, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.6
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateDict = self.calenderArr[indexPath.row] as! NSDictionary
        showAlertViewWithTitle(title: "YVOLV", message: "Do you want add this event to calender?")
    }

    func addEventToCalendar(title: String, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore : EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
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
    
    func showAlertViewWithTitle(title:String, message:String){
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Yes!", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let start = (self.updateDict.value(forKey: "startDate")! as! String).replace(target: " 00:00:00 GMT+0000", withString: "")
            let end = (self.updateDict.value(forKey: "endDate")! as! String).replace(target: " 00:00:00 GMT+0000", withString: "")
            
            self.addEventToCalendar(title: (self.updateDict.value(forKey: "Name") as? String)!, startDate: self.stringToDate(dateString: start), endDate: self.stringToDate(dateString: end)) { (response, error) in
                if response{
                    self.customAlert()
                    //UIApplication.shared.open(URL(fileURLWithPath: "calshow://"), options: [:], completionHandler: nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func customAlert(){
        let alert = UIAlertController(title: "Success", message: "Event Succesfully added to calendar!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func stringToDate(dateString:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE MMM dd yyyy" //Your date format
        let date = dateFormatter.date(from: dateString) //according to date format your date string
        return date!
    }
}
