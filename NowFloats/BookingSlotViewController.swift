//
//  BookingSlotViewController.swift
//  AnimationsProject
//
//  Created by Rama on 07/09/17.
//  Copyright © 2017 ongoStore. All rights reserved.
//

import UIKit
//let reuseTableViewCellIdentifier = "BookingTableViewCell"
//let reuseCollectionViewCellIdentifier = "BookingCollectionViewCell"
class BookingSlotViewController: CXViewController {

    @IBOutlet var appointmentTableView: UITableView!
     var storedOffsets = [Int: CGFloat]()
    var datesArray  = NSMutableArray()
    var filteredDatesArray = NSMutableArray()
    var timesArray = NSMutableArray()
    
    var jobTimeArray = NSArray()
    var createdSubJobArray = NSArray()
    var inTimeStr = String()
    var outTimeStr = String()
    var slotperiodStr = String()
   // var holidayArray = NSMutableArray()
    var holidayStr = String()
    var frmDateStr = String()
    var toDateStr = String()
    var cellArray = NSMutableArray()
    var bookedDateArray = NSArray()
    var bookedTimeArray = NSArray()
    var jobIdStr = String()
    var slotBookedDict = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        let nib = UINib(nibName: "BookingTableViewCell", bundle: nil)
        self.appointmentTableView.register(nib, forCellReuseIdentifier: "BookingTableViewCell")
        // Do any additional setup after loading the view.
         getUserSlots()
        self.registerTableViewCell()
           //  self.customCells()
       
        
    }
//    func customCells(){
//        
//        for i in self.datesArray {
//            let cell = Bundle.main.loadNibNamed("BookingTableViewCell",
//                                                owner: nil,
//                                                options: nil)?.first as! BookingTableViewCell
//            cellArray.add(cell)
//        }
//        
//        let nib = UINib(nibName: "BookingTableViewCell", bundle: nil)
//        self.appointmentTableView.register(nib, forCellReuseIdentifier: "BookingTableViewCell")
//        
//       
//        
//        self.appointmentTableView.contentInset = UIEdgeInsetsMake(0, 0,30, 0)
//        self.appointmentTableView.separatorStyle = .none
//        
//    }

    func getUserSlots() {
         CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
        /*User Slots:
        http://storeongo.com:8081/Services/getMasters?type=user%20slots&mallid=4724*/
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"User Slots" as AnyObject,"mallid":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
            // print("print Campaign\(responseDict)")
           CXDataService.sharedInstance.hideLoader()
            
            self.jobTimeArray = responseDict.value(forKey: "jobs") as! NSArray 
            print("jobTimeArray== \( self.jobTimeArray)")
            for activityData in  self.jobTimeArray{
                let dict:NSDictionary = activityData as! NSDictionary
                self.frmDateStr = (dict.value(forKey: "FromDate")!) as! String
                self.toDateStr = (dict.value(forKey: "ToDate")!) as! String
                self.inTimeStr = (dict.value(forKey: "In-Time")!) as! String
                self.outTimeStr = (dict.value(forKey: "Out_Time")!) as! String
                self.slotperiodStr = (dict.value(forKey: "Slot Period")!) as! String
                self.holidayStr = (dict.value(forKey: "Holidays")!)  as! String
                let jobId = (dict.value(forKey: "id")!) as! Int
                self.jobIdStr = String(jobId)
                self.createdSubJobArray = (dict.value(forKey: "CreatedSubJobs")) as! NSArray
            }
            
            for subJob in self.createdSubJobArray{
                let dict:NSDictionary = subJob as! NSDictionary
                
                let startDate = dict.value(forKey: "StartDate") as? String
                
                
                let keyExists = self.slotBookedDict[startDate] != nil
                if keyExists {
                    
                    var list = self.slotBookedDict.value(forKey: startDate!) as? [String]
                    list?.append(dict.value(forKey: "StartTime") as! String)
                
                    self.slotBookedDict.setValue(list, forKey: dict.value(forKey: "StartDate") as! String)

                }else{
                    var list = [dict.value(forKey: "StartTime")]
                    
                    self.slotBookedDict.setValue(list, forKey: dict.value(forKey: "StartDate") as! String)
                }
                CXLog.print(self.slotBookedDict)
                
                
                //self.bookedDateArray = (dict.value(forKey: "StartDate")!) as! String
                //self.bookedTimeArray = (dict.value(forKey: "StartTime")!) as! String
            }
             CXLog.print("selected DATES== \(self.bookedDateArray)")
             CXLog.print("selected times== \(self.bookedTimeArray)")
            
            self.printDatesBetweenInterval(self.dateFromString(self.frmDateStr),self.dateFromString(self.toDateStr))
            CXLog.print("ALL DATES== \(self.datesArray)")
            
            var holidaysArray = [String]()
            for dates in self.datesArray {
                let datestr = dates as? String
                if (datestr?.contains(self.holidayStr))!{
                    holidaysArray.append(datestr!)
                }
            }
            
            self.datesArray.removeObjects(in: holidaysArray)
            
            CXLog.print("ALL DATES without holidays== \(self.datesArray)")            

         self.makeTimeInterval(startTime: self.inTimeStr, endTime:   self.outTimeStr)
            CXLog.print("All time == \(self.timesArray)")
           self.appointmentTableView.reloadData()
            
        }

    }
    
    func makeTimeInterval(startTime:String ,endTime:String) -> String
    {
//        var arr = startTime.components(separatedBy: " ")[0].components(separatedBy: ":")
//        let str = arr[1] as String
//        if (/Users/rama/Documents/YVOLV/NowFloats.xcodeprojInt(str)! > 0 && Int(str)! < 30){
//            arr[1] = "00"
//        }
//        else if(Int(str)! > 30){
//            arr[1] = "30"
//        }
//        let startT:String = "\(arr.joined(separator: ":"))  \(startTime.components(separatedBy: " ")[1])"
        
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm"
        var fromTime:NSDate  = (timeFormat.date(from:startTime) as NSDate?)!
        let toTime:NSDate  = (timeFormat.date(from:endTime) as NSDate?)!
        
        var dateByAddingThirtyMinute : NSDate!
        let timeinterval : TimeInterval = toTime.timeIntervalSince(fromTime as Date)
        let numberOfIntervals : Double = timeinterval / 3600;
        var formattedDateString : String!
        //TO DO check the slot period nil
        //Time Interval
        let number = Int(self.slotperiodStr.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        let timeSlot = number!*60
        CXLog.print("timeinter== \(timeSlot)")
          var currentTime  = Date()
        for _ in stride(from: 0, to: Int(numberOfIntervals * 2), by: 1)
        {
            
            dateByAddingThirtyMinute = fromTime.addingTimeInterval(TimeInterval(timeSlot))
            fromTime = dateByAddingThirtyMinute
            let dateFormatter = DateFormatter()
           // dateFormatter.dateFormat = "HH:mm"
            dateFormatter.dateFormat = "hh:mm a"
            formattedDateString = dateFormatter.string(from: dateByAddingThirtyMinute! as Date) as String?
            
//            let startDateComparisionResult:ComparisonResult = currentTime.compare(dateByAddingThirtyMinute! as Date)
//            
//            if startDateComparisionResult == ComparisonResult.orderedAscending
//            {
//                // Current date is smaller than end date.
//                CXLog.print("Ascending==\(self.timesArray)")
//            }else if startDateComparisionResult == ComparisonResult.orderedDescending
//            {
//                 CXLog.print("Descending==\(self.timesArray)")
//              
//                // Current date is greater than end date.
//            }else if startDateComparisionResult == ComparisonResult.orderedSame
//            {
//                 CXLog.print("same==\(self.timesArray)")
//                // Current date and end date are same
//            }
//            if dateByAddingThirtyMinute! as Date > currentTime as Date{
//                 //self.timesArray.add(formattedDateString)
//            }
       self.timesArray.add(formattedDateString)
        }
        
        return formattedDateString
        
    }
    
    func registerTableViewCell(){
        self.appointmentTableView.backgroundColor = UIColor.clear
        self.appointmentTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.appointmentTableView.contentInset = UIEdgeInsetsMake(0, 0,30, 0)
        self.appointmentTableView.rowHeight = UITableViewAutomaticDimension
        self.appointmentTableView.showsVerticalScrollIndicator = false
        self.appointmentTableView.isScrollEnabled = true
    }

    
    func printDatesBetweenInterval(_ startDate: Date, _ endDate: Date) {
        var startDate = startDate
        let calendar = Calendar.current
        let currentDate = Date()
         let fmt = DateFormatter()
        let cuurentfmt = DateFormatter()
        cuurentfmt.dateFormat = "EEEE dd MMMM yyyy"
         cuurentfmt.timeZone = NSTimeZone(name: "UTC")! as TimeZone
           fmt.dateFormat = "EEEE dd MMMM yyyy"
           fmt.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        //fmt.dateFormat = "MM/dd/yyyy"
        
        
        while startDate <= endDate {
            if startDate >= currentDate{
                CXLog.print("dates== \(startDate)")
                 let datesStr = fmt.string(from: startDate)
                 datesArray.add(datesStr)
                
                CXLog.print("datesArray== \(datesArray)")
            }
            //datesArray.add(datesStr)
             startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                       }
          
        }
   
    
    func dateFromString(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
       
             dateFormatter.dateFormat = "MM/dd/yyyy"
          // dateFormatter.timeZone = NSTimeZone.local
        //dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
        
        return dateFormatter.date(from: dateString)!
    }
    
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        return false
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        return false
    }
    
    override  func shouldShowCart() -> Bool{
        return false
    }
    
    override func headerTitleText() -> String{
        return "Book Your Time"
    }
    
    override func shouldShowLeftMenu() -> Bool{
        return false
    }
    
    override func shouldShowLeftMenuWithLogo() -> Bool{
        return false
    }
    
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    
    override func profileDropdown() -> Bool{
        return false
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }
    

    


    
}
extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
extension BookingSlotViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.datesArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = cellArray[indexPath.row] as! BookingTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingTableViewCell", for: indexPath)as? BookingTableViewCell
        
        cell?.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
        cell?.headerLbl.text = self.datesArray[indexPath.section] as? String
         cell?.headerLbl.tag = indexPath.section
        cell?.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        cell?.selectionStyle = .none
        return cell!
    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        guard let tableViewCell = cell as? BookingTableViewCell else { return }
//        
//        //tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
//        //tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
//    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension BookingSlotViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.timesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCollectionViewCell", for: indexPath)as? BookingCollectionViewCell
        cell?.delegate = self
        let dateTxt = self.timesArray[indexPath.item] as! String
        
        cell?.timeSlotBtn.tag = collectionView.tag
        cell?.timeSlotBtn.setTitle(dateTxt, for: .normal)

        
        let keyExists = self.slotBookedDict[self.datesArray[collectionView.tag]] != nil
        if keyExists {
            let list =  self.slotBookedDict[self.datesArray[collectionView.tag]] as? [String]
            if (list?.contains(dateTxt))! {
                cell?.timeSlotBtn.isEnabled = false
                cell?.timeSlotBtn.layer.borderColor = UIColor.init(red: 222/255.0, green: 179/255.0, blue: 43/255.0, alpha: 1).cgColor
                cell?.timeSlotBtn.setTitleColor(UIColor.init(red: 222/255.0, green: 179/255.0, blue: 43/255.0, alpha: 1), for: .normal)
                cell?.timeSlotBtn.backgroundColor = UIColor.init(red: 222/255.0, green: 179/255.0, blue: 43/255.0, alpha: 0.1)
                
            }else{
                cell?.timeSlotBtn.isEnabled = true
                cell?.timeSlotBtn.addTarget(self, action: #selector(getBtnAction(sender:)), for: .touchUpInside)
                cell?.timeSlotBtn.layer.borderColor = UIColor.init(red: 37/255.0, green: 151/255.0, blue: 126/255.0, alpha: 1).cgColor
                cell?.timeSlotBtn.setTitleColor(UIColor.init(red: 37/255.0, green: 151/255.0, blue: 126/255.0, alpha: 1), for: .normal)
                cell?.timeSlotBtn.backgroundColor = UIColor.white
            }
        }else{
            cell?.timeSlotBtn.isEnabled = true
           // cell?.timeSlotBtn.addTarget(self, action: #selector(getBtnAction(sender:)), for: .touchUpInside)
            cell?.timeSlotBtn.layer.borderColor = UIColor.init(red: 37/255.0, green: 151/255.0, blue: 126/255.0, alpha: 1).cgColor
            cell?.timeSlotBtn.setTitleColor(UIColor.init(red: 37/255.0, green: 151/255.0, blue: 126/255.0, alpha: 1), for: .normal)
            cell?.timeSlotBtn.addTarget(self, action: #selector(getBtnAction(sender:)), for: .touchUpInside)
            cell?.timeSlotBtn.backgroundColor = UIColor.white
        }
        
        
        return cell!
     
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        // Set cell width to 100%
        let tableViewHeigh : CGFloat = 667
        let DetailCollectionCellSize :  CGSize = CGSize(width: 80,height: 80)
        return DetailCollectionCellSize
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    func getBtnAction(sender:UIButton) {
        CXLog.print(sender.titleLabel?.text)
        CXLog.print(datesArray.object(at: sender.tag))
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppointmentDetailsViewController") as? AppointmentDetailsViewController
        let selectedTimeStr = sender.titleLabel?.text!
        let dict = ["time":selectedTimeStr!,"date":datesArray.object(at: sender.tag) as! AnyHashable ,"jobID":jobIdStr] as! [AnyHashable : String]
        storyboard?.dateNtimeDict = dict as NSDictionary
        self.navigationController?.pushViewController(storyboard!, animated: true)
    }
    
}

extension BookingSlotViewController : BookingSlotDelegate{
    
    func didSelectSlot(cellObject: Any) {
        
    }
}


