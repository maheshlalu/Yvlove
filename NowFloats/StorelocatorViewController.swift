//
//  StorelocatorViewController.swift
//  NowFloats
//
//  Created by Rama kuppa on 02/05/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class StorelocatorViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var storeTableView: UITableView!
    
    var storeArray = [[String:AnyObject]]()
    var store = NSMutableArray()
    var categoryNameArray = NSMutableArray()
    var categoryJobArray = NSMutableArray()
    var categories = [String]()
    var mainDataDict = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.downloadData()
        
        let nib = UINib(nibName: "StorelocatorTableViewCell", bundle: nil)
        self.storeTableView.register(nib, forCellReuseIdentifier: "StorelocatorTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    func downloadData(){
        
        
                  /*  CXAppDataManager.sharedInstance.getStoreCategories(completion: { (responseDic) in
                        print("print Stores\(responseDic)")
                        var numbers = [self.categoryNameArray]
                                            numbers.uniqInPlace()
                                            print(numbers)
                         self.categoryJobArray = responseDic.value(forKey: "jobs")as! NSArray as! NSMutableArray
                        print(self.categoryJobArray)
                        for obj in self.categoryJobArray{
                            let dict = obj as! NSDictionary
                            self.categoryNameArray.add(dict.value(forKey: "City")as! String)
                        }
        
                    
                    })*/
//
        let url = NSURL(string: "http://storeongo.com:8081/Services/getMasters?type=Stores&mallId=31")
        
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest) { (downloadData, response, error) in
            
            print(downloadData)
            
            if error == nil
            {
                do
                {
                    let dict = try JSONSerialization.jsonObject(with: downloadData!, options: .allowFragments) as! [String :AnyObject]
                    
                    print(dict)
                    
                    
                    
                    self.storeArray = dict["jobs"]as! [[String:AnyObject]]
//                    for i in 1...self.storeArray.count {
////                        let index = IndexPath.init(row: 1, section: lastIndexOfArr + i)
////                        indexSet.add(lastIndexOfArr + i)
////                        indexArr.add(index)
//                        print(i)
//                    }
//                    
//                    for element in self.storeArray {
//                        let dict = element as NSDictionary
//                        self.store.add(dict.value(forKey: "City"))
//                        print(self.store)
//                        
//                    }
//                   
//                    self.categories = self.store as! [String]
//                    self.categories.uniqInPlace()
//                    print(self.categories)
//                    
//                    
//                    for element in self.categories {
//                        let category = element as String
//                        let tempArr = NSMutableArray()
//                        for element in self.storeArray {
//                            let dict = element as NSDictionary
//                            if dict.value(forKey: "City") as! String == category {
//                                tempArr.add(dict)
//                                print(tempArr)
//                            }
//                        }
//                        self.mainDataDict[category] = tempArr
//                        print(self.mainDataDict)
//                    }
//                    
//                    print(self.mainDataDict)
                    
                    
                    print(self.storeArray.count)
                    print(self.storeArray)
                    DispatchQueue.main.async(execute: {
                        self.storeTableView.reloadData()
                        
                    })
                    
                    
                }
                catch let jsonError as NSError
                {
                    print(jsonError)
                }
            }
        }
        dataTask.resume()//start download
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.categories[section]
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
       return storeArray.count
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let dict = storeArray[indexPath.row]
        print(dict)
//        let dict = categoryJobArray[indexPath.row]
//        print(dict)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StorelocatorTableViewCell", for: indexPath)as? StorelocatorTableViewCell
        
        cell?.citeNameLabel.text = dict["City"]as? String
        cell?.productNameLabel.text = dict["createdByFullName"]as? String
        cell?.mobileNumberLabel.text = dict["Contact Number"]as? String
        cell?.addressLabel.text = dict["Address"]as? String
        cell?.timeLabel.text = dict[""]as? String
        cell?.selectionStyle = .none
        return cell!
    }

  

}


extension Array where Element: Equatable {
    
    public func uniq() -> [Element] {
        var arrayCopy = self
        arrayCopy.uniqInPlace()
        return arrayCopy
    }
    
    mutating public func uniqInPlace() {
        var seen = [Element]()
        var index = 0
        for element in self {
            if seen.contains(element) {
                remove(at: index)
            } else {
                seen.append(element)
                index += 1
            }
        }
    }
}
