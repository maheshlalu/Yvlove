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
    var productCategeryType = String()
    var referID = String()
    var additinalDataArr = NSArray()
    var categoryArr = NSMutableArray()
    var boolArray = NSMutableArray()
    var selectedCategoryType = String()
    var selectedSubCategoryType = String()
    var selectedP3Category = String()
    
    @IBOutlet weak var noProductlbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedCategoryType)
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255.0, green: 145/255.0, blue: 0/255.0, alpha: 1.0)
        self.productSubCategeryServiceCall(categeryType: productCategeryType, referID: referID)
        
        self.noProductlbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.additinalTable.backgroundColor = UIColor.lightGray
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
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CartAction"), object: nil)
        }
    }
    
    //MARK: product MasterCategery
    func productSubCategeryServiceCall(categeryType: String,referID: String){
        // http://apps.storeongo.com:8081/Services/getMasters?type=pSubCategories&mallId=396&refTypeProperty=MasterCategory&refId=12872
        self.additinalTable.isHidden = false
        self.additinalDataArr = NSMutableArray()
        let dataKyes = ["type":"pSubCategories","mallId":CXAppConfig.sharedInstance.getAppMallID(),"refTypeProperty":"MasterCategory","refId":referID] as [String : Any]
        CXDataService.sharedInstance.getTheAppDataFromServer(dataKyes as [String : AnyObject]) { (responceDic) in
            let jobsData:NSArray = responceDic.value(forKey: "jobs")! as! NSArray
            if jobsData.count == 0{
                // self.showAlertView("No Products right now here", status: 1)
                self.additinalTable.isHidden = true
            }else{
                for dictData in jobsData {
                    let dictindividual : NSDictionary =  (dictData as? NSDictionary)!
                    self.categoryArr.add(dictindividual)
                    self.boolArray.add(true)
                }
                self.additinalTable.reloadData()
            }
        }
    }
    
    //MARK: AlertView
    func showAlertView(_ message:String, status:Int) {
        let alert = UIAlertController(title: "Alert!!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if status == 1 {
                
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Get Sub With Sub categery items
    func productSubWithSubCategeryServiceCall(categeryType: String,referID: String){
        // http://apps.storeongo.com:8081/Services/getMasters?type=p3rdlevelCategories&mallId=396&refTypeProperty=SubCategory&refId=8043
        self.additinalDataArr = NSMutableArray()
        let dataKyes = ["type":"p3rdlevelCategories","mallId":CXAppConfig.sharedInstance.getAppMallID(),"refTypeProperty":"SubCategory","refId":referID] as [String : Any]
        CXDataService.sharedInstance.getTheAppDataFromServer(dataKyes as [String : AnyObject]) { (responceDic) in
            self.additinalDataArr = responceDic.value(forKey: "jobs")! as! NSArray
            if self.additinalDataArr.count == 0{
                self.showAlertView("No Products right now here", status: 1)
                self.additinalTable.reloadData()
            }else{
                DispatchQueue.main.async {
                    self.additinalTable.reloadData()
                }
            }
        }
    }
}

extension productDetailSubCategery : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemented
    {
        return categoryArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if boolArray[section] as! Bool {
            return additinalDataArr.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let subDict = self.additinalDataArr.object(at: indexPath.row) as! NSDictionary
        cell.textLabel?.text = subDict.value(forKey: "Name") as? String
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let dict = self.additinalDataArr.object(at: indexPath.row) as! NSDictionary
        selectedP3Category = NSString.init(format: "%@(%@)", dict.value(forKey: "Name") as! CVarArg,dict.value(forKey: "id") as! CVarArg) as String
        self.dismiss(animated: true) {
            let selectedStr = "\(self.selectedCategoryType)|\(self.selectedSubCategoryType)|\(self.selectedP3Category)"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FilterSelectionCompleted"), object: selectedStr)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CartAction"), object: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        view.backgroundColor = UIColor.lightGray
        let label = UILabel.init(frame: CGRect(x: 10, y: 12, width: tableView.frame.size.width, height: 20))
        let subDict = self.categoryArr.object(at: section) as! NSDictionary
        label.text = subDict.value(forKey: "Name") as? String
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.white
        view.addSubview(label)
        
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        btn.addTarget(self, action: #selector(headerBtnClicked), for: .touchUpInside)
        btn.tag = section
        view.addSubview(btn)
        return view
    }
    
    func headerBtnClicked(sender:UIButton)
    {
        let dict = categoryArr[sender.tag] as! NSDictionary
        selectedSubCategoryType = NSString.init(format: "%@(%@)", dict.value(forKey: "Name") as! CVarArg,dict.value(forKey: "id") as! CVarArg) as String
        boolArray.removeAllObjects()
        for (index, element) in categoryArr.enumerated() {
            if index == sender.tag {
                self.boolArray.add(true)
            }
            else {
                self.boolArray.add(false)
            }
        }
        productSubWithSubCategeryServiceCall(categeryType: dict.value(forKey: "Name") as! String, referID: CXAppConfig.resultString(input: dict.value(forKey: "id") as AnyObject))
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


