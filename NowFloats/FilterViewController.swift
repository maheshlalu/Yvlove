//
//  FilterViewController.swift
//  NowFloats
//
//  Created by SRINIVASULU on 20/03/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var filterTableView: UITableView!
    // var selectedIndex:NSIndexPath?
    // Arrays
    var priceArr = NSMutableArray()
    var priceSelectedArr = NSMutableArray()
    var priceKey = NSString()
    var finalPriceSelectedArr = NSMutableArray()
    
    var ageArr = NSMutableArray()
    var ageSelectedArr = NSMutableArray()
    var ageKey = NSString()
    var finalAgeSelectedArr = NSMutableArray()
    
    var discountArr = NSMutableArray()
    var discountSelectedArr = NSMutableArray()
    var discountKey = NSString()
    var finalDiscountSelectedArr = NSMutableArray()
    
    var colorArr = NSMutableArray()
    var colorSelectedArr = NSMutableArray()
    var colorKey = NSString()
    var colorKeyword = NSString()
    var products = NSArray()
    var finalColorSelectedArr = NSMutableArray()
    var colorCode = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Price
        self.priceKey = "Price"
        self.priceArr = ["0 - 500","500 - 1000","1000 - 2000","More Than 2000"]
        for _ in 0 ..< self.priceArr.count {
            (priceSelectedArr as AnyObject).add("NO")
        }
        // age
        self.ageKey = "Age"
        self.ageArr = ["1-4 Years","2-3 Years","0-2 years","2-5 years","2-6 years","3-8 Years"]//"0-3 Months","3-6 Months","6-12 Months","12-18 Months","18-24 Months","2-3 Years","3-4 Years","4-5 Years"
        for _ in 0 ..< self.ageArr.count {
            (ageSelectedArr as AnyObject).add("NO")
        }
        //Discount
        self.discountKey = "Discount"
        self.discountArr = ["5%","10%","20%","30%"]
        for _ in 0 ..< self.discountArr.count {
            (discountSelectedArr as AnyObject).add("NO")
        }
        // color
        self.colorKey = "ColorWord"
        self.colorArr = ["Black","White","Red","Blue","Yellow","Maroon","Silver","Biege","Brown","Peach","Orange","Purple/Violet","Grey","Green","Multicolor"]
        self.colorCode = ["000000","FFFFFF","FF0000","0000FF","FFFF00","bd012e","c7c7c7","ffe8c5","983900","ffcc99","ff6c00","4100ad","5c5c5c","008000",""]
        for _ in 0 ..< self.colorArr.count {
            (colorSelectedArr as AnyObject).add("NO")
        }
        //print("selected \(selectedArr)")
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255.0, green: 145/255.0, blue: 0/255.0, alpha: 1.0)
        self.navigationItem.title = "Filter's Selection"
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        let nib = UINib(nibName: "customcellFilter", bundle: nil)
        self.filterTableView.register(nib, forCellReuseIdentifier: "Cell")
        let colorCell = UINib(nibName: "customColorCell", bundle: nil)
        self.filterTableView.register(colorCell, forCellReuseIdentifier: "Cellcolor")
        filterTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let menuItem = UIBarButtonItem(image: UIImage(named: "LeftArrow"), style: .plain, target: self, action: #selector(FilterViewController.backBtnClicked))
        self.navigationItem.leftBarButtonItem = menuItem
        let save = UIBarButtonItem.init(title: "Filter", style: .plain, target: self, action: #selector(FilterViewController.filterTapped))
        self.navigationItem.rightBarButtonItem = save
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    func backBtnClicked()
    {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: filter Action
    func filterTapped(){
        
        print("seleted arrays \(finalPriceSelectedArr) \(finalAgeSelectedArr) \(finalDiscountSelectedArr)  \(finalColorSelectedArr)")
        
        /*let converstationKeyPredicate = NSPredicate(format: "conversationKey = %@", conversationKey)
         let messageKeyPredicate = NSPredicate(format: "messageKey = %@", messageKey)
         let andPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [converstationKeyPredicate, messageKeyPredicate])
         request.predicate = andPredicate
         */
        
//        let mainPredicate:NSCompoundPredicate = NSCompoundPredicate()
//        let subPredicates:NSPredicate = NSPredicate()
        
        let dataArr = NSMutableArray()
        var predicateStr:String = String()
        var pricePredicateString:String = String()
        var agePredicateString:String = String()
        var discountPredicateString:String = String()
        var colorPredicateString:String = String()
        
        //Price Predicate Construction
        if finalPriceSelectedArr.count != 0{
            if finalPriceSelectedArr.description.contains("0 - 500"){
                pricePredicateString = " pPrice>=0 AND pPrice<=500 #"
            }
            if finalPriceSelectedArr.description.contains("500 - 1000"){
                pricePredicateString = pricePredicateString + " pPrice>=500 AND pPrice<=1000 #"
            }
            if finalPriceSelectedArr.description.contains("1000 - 2000"){
                pricePredicateString = pricePredicateString + " pPrice>=1000 AND pPrice<=2000 #"
            }
            if finalPriceSelectedArr.description.contains("More Than 2000"){
                pricePredicateString = pricePredicateString + " pPrice>=2000 #"
            }
            
            let finalOne = String(pricePredicateString.characters.dropLast())
            pricePredicateString = finalOne.replacingOccurrences(of: "#", with: "OR")
            pricePredicateString = "(\(pricePredicateString))"
            dataArr.add(pricePredicateString)
        }
        
        //"0-3 Months","3-6 Months","6-12 Months","12-18 Months","18-24 Months","2-3 Years","3-4 Years","4-5 Years"
        //SELECT * FROM ZCX_PRODUCTS WHERE ZAGE="1-4 Years" OR ZAGE="2-3 Years"
        //SELECT * FROM ZCX_PRODUCTS WHERE ZPPRICE >=80 AND ZPPRICE<=150 OR  ZPPRICE >=0 AND ZPPRICE<=100 OR  ZPPRICE >=100 AND ZPPRICE<=2000 OR ZPPRICE>=2000 FOR PRICE
        //SELECT * FROM ZCX_PRODUCTS WHERE (ZPPRICE >=0 AND ZPPRICE <=500 OR ZPPRICE >=1000 AND ZPPRICE <=2000) AND (ZAGE="0-2 years" OR ZAGE="2-5 years" OR ZAGE="1-4 Years" OR ZAGE="2-3 Years" OR ZAGE="3-8 Years")
        //###########################################################################################################################################
        /* //Age Predicate Construction
         if finalAgeSelectedArr.count != 0{
         if finalAgeSelectedArr.description.contains("0-3 Months"){
         pricePredicateString = " pPrice>=0 AND pPrice<=500 #"
         }
         
         if finalAgeSelectedArr.description.contains("3-6 Months"){
         pricePredicateString = pricePredicateString + " pPrice>=500 AND pPrice<=1000 #"
         }
         
         if finalAgeSelectedArr.description.contains("6-12 Months"){
         pricePredicateString = pricePredicateString + " pPrice>=1000 AND pPrice<=2000 #"
         }
         
         if finalAgeSelectedArr.description.contains("12-18 Months"){
         pricePredicateString = pricePredicateString + " pPrice>=2000 #"
         }
         
         if finalAgeSelectedArr.description.contains("18-24 Months"){
         pricePredicateString = pricePredicateString + " pPrice>=2000 #"
         }
         
         if finalAgeSelectedArr.description.contains("2-3 Years"){
         pricePredicateString = pricePredicateString + " pPrice>=2000 #"
         }
         
         if finalAgeSelectedArr.description.contains("3-4 Years"){
         pricePredicateString = pricePredicateString + " pPrice>=2000 #"
         }
         
         if finalAgeSelectedArr.description.contains("4-5 Years"){
         pricePredicateString = pricePredicateString + " pPrice>=2000 #"
         }
         
         
         let finalOne = String(pricePredicateString.characters.dropLast())
         pricePredicateString = finalOne.replacingOccurrences(of: "#", with: "OR")
         print(pricePredicateString)
         
         }
         */
        //###########################################################################################################################################
        
        
        //Dummy Age predicate. Please remove after updation of server. For any queries consult Naresh.
        //"1-4 Years","2-3 Years","0-2 years","2-5 years","2-6 years","3-8 Years" --- Dummy array
        if finalAgeSelectedArr.count != 0{
            
            var filteredData:String = String()
            for filter in finalAgeSelectedArr{
                filteredData = filteredData + " age=\"\(filter)\" #"
            }
            
            let finalOne = String(filteredData.characters.dropLast())
            agePredicateString = finalOne.replacingOccurrences(of: "#", with: "OR")
            agePredicateString = "(\(agePredicateString))"
            dataArr.add(agePredicateString)
        }
        
        //Discount Predicate Construction
        if finalDiscountSelectedArr.count != 0{
            var filteredData:String = String()
            for filter in finalDiscountSelectedArr{
                filteredData = filteredData + " discountprice=\"\(String((filter as! String).characters.dropLast()))\" #"
            }
            let finalOne = String(filteredData.characters.dropLast())
            discountPredicateString = finalOne.replacingOccurrences(of: "#", with: "OR")
            discountPredicateString = "(\(discountPredicateString))"
            dataArr.add(discountPredicateString)
        }
        
        //Color Predicate Construction
        if finalColorSelectedArr.count != 0 {
            var filteredData:String = String()
            for filter in finalColorSelectedArr{
                //let predicate = NSPredicate.init(format: "categoryType contains[c] %@ && subCategoryType contains[c] %@ && p3rdCategory contains[c] %@",filterArr[0],filterArr[1],filterArr[2])
                filteredData = filteredData + " metaData contains[c] \"\(filter)\" #"
            }
            let finalOne = String(filteredData.characters.dropLast())
            colorPredicateString = finalOne.replacingOccurrences(of: "#", with: "OR")
            colorPredicateString = "(\(colorPredicateString))"
            dataArr.add(colorPredicateString)
        }
        
        //Attaching the complete predicate
        var filteredData:String = String()
        for filter in dataArr{
            filteredData = "\(filteredData) AND \(filter)"
        }
        let finalPredicate = String(filteredData.characters.dropFirst(5))
        print(finalPredicate)
        predicateStr = finalPredicate
        
        var dummyArr = NSArray()
        let predicate = NSPredicate.init(format:predicateStr)
        dummyArr = CX_Products.mr_findAll(with: predicate) as NSArray!
        print(dummyArr.count)
        
        self.dismiss(animated: true) {
            let filteredProductArry = dummyArr
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FILTER_COMPLETED"), object: filteredProductArry)
        }
        
    }
    
    // tableview Data Source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if priceKey == "Price"{
            return self.priceArr.count
        }else if ageKey == "Age" {
            return self.ageArr.count
        }else if discountKey == "Discount"
        {
            return self.discountArr.count
        }else if colorKeyword == "ColorWord"{
            return self.colorArr.count
        }else {
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if colorKeyword == "ColorWord"{
            let cell:customColorCell = tableView.dequeueReusableCell(withIdentifier: "Cellcolor", for: indexPath) as! customColorCell
            cell.nameLbl.text = self.colorArr.object(at: indexPath.row) as? String
            
            if cell.nameLbl.text == "Multicolor"{
                cell.viewColor.backgroundColor = UIColor(patternImage:UIImage(named:"multiColor")!)
            }else{
                cell.viewColor.backgroundColor = UIColor().HexToColor(hexString: self.colorCode.object(at: indexPath.row) as! String, alpha: 1.0)
            }
            
            cell.viewColor.layer.borderWidth = 1
            cell.viewColor.layer.cornerRadius = 4
            cell.viewColor.layer.borderColor = UIColor.lightGray.cgColor
            cell.checkBtncolor.addTarget(self, action: #selector(FilterViewController.radioBtnTapped(_:)), for: .touchUpInside)
            cell.checkBtncolor.tag = indexPath.row + 100
            let values : String = colorSelectedArr.object(at: indexPath.row) as! String
            if values == "NO"{
                cell.checkBtncolor.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                cell.checkBtncolor.isSelected = false
            }else{
                cell.checkBtncolor.setImage(UIImage(named: "CheckedFill"), for: .normal)
                cell.checkBtncolor.isSelected = true
            }
            return cell
        }else{
            let cell:customcellFilter = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! customcellFilter
            if priceKey == "Price"{
                cell.name.text = self.priceArr.object(at: indexPath.row) as? String
                cell.radioButton.addTarget(self, action: #selector(FilterViewController.radioBtnTapped(_:)), for: .touchUpInside)
                cell.radioButton.tag = indexPath.row + 100
                let values : String = priceSelectedArr.object(at: indexPath.row) as! String
                if values == "NO"{
                    cell.radioButton.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                    cell.radioButton.isSelected = false
                }else{
                    cell.radioButton.setImage(UIImage(named: "CheckedFill"), for: .normal)
                    cell.radioButton.isSelected = true
                }
            }else if ageKey == "Age" {
                cell.name.text = self.ageArr.object(at: indexPath.row) as? String
                cell.radioButton.addTarget(self, action: #selector(FilterViewController.radioBtnTapped(_:)), for: .touchUpInside)
                cell.radioButton.tag = indexPath.row + 100
                let values : String = ageSelectedArr.object(at: indexPath.row) as! String
                if values == "NO"{
                    cell.radioButton.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                    cell.radioButton.isSelected = false
                    //
                }else{
                    cell.radioButton.setImage(UIImage(named: "CheckedFill"), for: .normal)
                    cell.radioButton.isSelected = true
                }
            }else if discountKey == "Discount"
            {
                cell.name.text = self.discountArr.object(at: indexPath.row) as? String
                cell.radioButton.addTarget(self, action: #selector(FilterViewController.radioBtnTapped(_:)), for: .touchUpInside)
                cell.radioButton.tag = indexPath.row + 100
                let values : String = discountSelectedArr.object(at: indexPath.row) as! String
                if values == "NO"{
                    cell.radioButton.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                    cell.radioButton.isSelected = false
                    //
                }else{
                    cell.radioButton.setImage(UIImage(named: "CheckedFill"), for: .normal)
                    cell.radioButton.isSelected = true
                }
            }
            return cell
        }
    }
    func radioBtnTapped(_ sender: UIButton)
    {
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            if priceKey == "Price"{
                priceSelectedArr.replaceObject(at: sender.tag - 100, with: "NO")
                finalPriceSelectedArr.remove(priceArr.object(at: sender.tag - 100))
            }else if ageKey == "Age" {
                ageSelectedArr.replaceObject(at: sender.tag - 100, with: "NO")
                finalAgeSelectedArr.remove(ageArr.object(at: sender.tag - 100))
            }else if discountKey == "Discount"
            {
                discountSelectedArr.replaceObject(at: sender.tag - 100, with: "NO")
                finalDiscountSelectedArr.remove(discountArr.object(at: sender.tag - 100))
            }else if colorKeyword == "ColorWord"{
                colorSelectedArr.replaceObject(at: sender.tag - 100, with: "NO")
                finalColorSelectedArr.remove(colorArr.object(at: sender.tag - 100))
            }
        }else{
            sender.isSelected = true
            sender.setImage(UIImage(named: "CheckedFill"), for: .normal)
            if priceKey == "Price"{
                priceSelectedArr.replaceObject(at: sender.tag - 100, with: "YES")
                finalPriceSelectedArr.add(priceArr.object(at: sender.tag - 100))
            }else if ageKey == "Age" {
                ageSelectedArr.replaceObject(at: sender.tag - 100, with: "YES")
                finalAgeSelectedArr.add(ageArr.object(at: sender.tag - 100))
            }else if discountKey == "Discount"
            {
                discountSelectedArr.replaceObject(at: sender.tag - 100, with: "YES")
                finalDiscountSelectedArr.add(discountArr.object(at: sender.tag - 100))
            }else if colorKeyword == "ColorWord"{
                colorSelectedArr.replaceObject(at: sender.tag - 100, with: "YES")
                finalColorSelectedArr.add(colorArr.object(at: sender.tag - 100))
            }
        }
        
    }
    //MARK: Price action
    @IBAction func priceBtnTapped(_ sender: Any) {
        colorKeyword = ""
        self.priceKey = "Price"
        self.ageKey = ""
        self.discountKey = ""
        self.filterTableView.reloadData()
    }
    //MARK: Age action
    @IBAction func agebtnTapped(_ sender: Any) {
        self.colorKeyword = ""
        self.priceKey = ""
        self.ageKey = "Age"
        self.discountKey = ""
        self.filterTableView.reloadData()
    }
    //MARK: Discount action
    @IBAction func discountBtnTapped(_ sender: Any) {
        self.colorKeyword = ""
        self.priceKey = ""
        self.ageKey = ""
        self.discountKey = "Discount"
        self.filterTableView.reloadData()
    }
    //MARK: Color action
    @IBAction func colorBtnTapped(_ sender: Any) {
        self.colorKeyword = "ColorWord"
        self.priceKey = ""
        self.ageKey = ""
        self.discountKey = ""
        self.filterTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension UIColor{
    func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}
