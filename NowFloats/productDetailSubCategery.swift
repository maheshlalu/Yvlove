//
//  productDetailSubCategery.swift
//  NowFloats
//
//  Created by SRINIVASULU on 21/03/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class productDetailSubCategery: UIViewController {
    @IBOutlet weak var additinalTable: UITableView!
    var productCategeryType = NSString()
    var referID = NSNumber()
    var additinalDataArr = NSMutableArray()
    var categoryArr = NSMutableArray()
    var boolArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255.0, green: 145/255.0, blue: 0/255.0, alpha: 1.0)
      //  print("categery \(productCategeryType)")
        // Do any additional setup after loading the view.
        self.productSubCategeryServiceCall(categeryType: productCategeryType as String, referID: referID)
        self.additinalTable.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        let menuItem = UIBarButtonItem(image: UIImage(named: "LeftArrow"), style: .plain, target: self, action: #selector(productDetailSubCategery.backBtnClicked))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    func backBtnClicked()
    {
        
        self.dismiss(animated: true, completion: nil)
        //        if subCategeryStr == "Subcate"{
        //        productSubCategeryServiceCall(categeryType: "", referID: 22)
        //        }else{
        //        self.dismiss(animated: true, completion: nil)
        //        }
    }
    
    //MARK: product MasterCategery
    func productSubCategeryServiceCall(categeryType: String,referID: NSNumber){
        // http://apps.storeongo.com:8081/Services/getMasters?type=pSubCategories&mallId=396&refTypeProperty=MasterCategory&refId=12872
        
        self.additinalDataArr = NSMutableArray()
        let dataKyes = ["type":"pSubCategories","mallId":CXAppConfig.sharedInstance.getAppMallID(),"refTypeProperty":"MasterCategory","refId":"12872"] as [String : Any]
        CXDataService.sharedInstance.getTheAppDataFromServer(dataKyes as [String : AnyObject]) { (responceDic) in
            let jobsData:NSArray = responceDic.value(forKey: "jobs")! as! NSArray
            for dictData in jobsData {
                let dictindividual : NSDictionary =  (dictData as? NSDictionary)!
                //let name:String = (dictindividual.value(forKey: "Name") as? String)!
                self.categoryArr.add(dictindividual)
                self.boolArray.add("on")
            }
            
            self.additinalTable.reloadData()
            
        }
        
    }
    //MARK: Get Sub With Sub categery items
    func productSubWithSubCategeryServiceCall(categeryType: String,referID: NSNumber){
        // http://apps.storeongo.com:8081/Services/getMasters?type=p3rdlevelCategories&mallId=396&refTypeProperty=SubCategory&refId=8043
        self.additinalDataArr = NSMutableArray()
        let dataKyes = ["type":"p3rdlevelCategories","mallId":CXAppConfig.sharedInstance.getAppMallID(),"refTypeProperty":"SubCategory","refId":"8043"] as [String : Any]
        CXDataService.sharedInstance.getTheAppDataFromServer(dataKyes as [String : AnyObject]) { (responceDic) in
            let jobsData:NSArray = responceDic.value(forKey: "jobs")! as! NSArray
            for dictData in jobsData {
                let dictindividual : NSDictionary =  (dictData as? NSDictionary)!
                //let name:String = (dictindividual.value(forKey: "Name") as? String)!
                self.additinalDataArr.add(dictindividual)
            }
            
            self.additinalTable.reloadData()
            
        }
        
    }
    /*
     //MARK: Extenal Data Tableview Delegate & Data Sources Methods
     
     func numberOfSections(in tableView: UITableView) -> Int {
     return 1
     }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return self.additinalDataArr.count
     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
     let subDict = self.additinalDataArr.object(at: indexPath.row) as! NSDictionary
     cell.textLabel?.text = subDict.value(forKey: "Name") as? String
     cell.textLabel?.textColor = UIColor.lightGray
     // cell.textLabel?.text = self.arrAdditinalCategery.object(at: indexPath.row) as? String
     return cell
     }
     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
     return UIView(frame: .zero)
     }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
     self.productSubWithSubCategeryServiceCall(categeryType: "", referID: 888)
     
     }
     */
}
extension productDetailSubCategery : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemented
    {
        return categoryArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        view.backgroundColor = UIColor.lightGray
        
        let label = UILabel.init(frame: CGRect(x: tableView.frame.size.width / 2 - 50, y: 12, width: 100, height: 20))
        //label.text = categoryArr[section] as? String
        let subDict = self.categoryArr.object(at: section) as! NSDictionary
        label.text = subDict.value(forKey: "Name") as? String
        label.textAlignment = NSTextAlignment.center
        view.addSubview(label)
        
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        btn.addTarget(self, action: #selector(headerBtnClicked), for: .touchUpInside)
        btn.tag = section
        view.addSubview(btn)
        
        return view
    }
    
    func headerBtnClicked(sender:UIButton)
    {
//        if boolArray[sender.tag] {
//            boolArray.remove(at: sender.tag)
//            boolArray.insert(false, at: sender.tag)
//        }
//        else {
//            boolArray.remove(at: sender.tag)
//            boolArray.insert(true, at: sender.tag)
//        }
        additinalTable.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        //let arr = subCategoryArr[indexPath.section] as NSArray
        cell.textLabel?.text = "Data"
        return cell
    }
    
    
    
    
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


