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
        self.ageArr = ["0-3 Months","3-6 Months","6-12 Months","12-18 Months","18-24 Months","2-3 Years","3-4 Years","4-5 Years"]
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
        self.colorArr = ["Black","White","Red","Blue","Yellow","Maroon","Silver","Biege","Brown","Peach","Orange","Purple/ Violet","Grey","Green"]
        self.colorCode = ["000000","FFFFFF","FF0000","0000FF","FFFF00","bd012e","c7c7c7","ffe8c5","983900","ffcc99","ff6c00","4100ad","5c5c5c","008000"]
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
       let dic = NSMutableDictionary()
        if finalPriceSelectedArr.count != 0{
        dic.setValue(finalPriceSelectedArr, forKey: "PRICE")
        }
        if finalAgeSelectedArr.count != 0{
        dic.setValue(finalAgeSelectedArr, forKey: "AGE")
        }
        if finalDiscountSelectedArr.count != 0 {
        dic.setValue(finalAgeSelectedArr, forKey: "DISCOUNT")
        }
        if finalColorSelectedArr.count != 0 {
        dic.setValue(finalColorSelectedArr, forKey: "COLOR")
        }
        for dictValues in dic{
            //let dictva = dictValues.value
            print("arrays \(dictValues.key)")
       
            
        
        }
        
//        let fetchRequest :  NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CX_Products")
//        for str in finalColorSelectedArr{
//            
//        let predicate =  NSPredicate(format: "metaData contains[c] %@" , argumentArray: [str])
//        
//            fetchRequest.predicate = predicate
//                    let arr:NSArray  =  CX_Products.mr_findAll(with: predicate) as NSArray
//                    for data in arr
//                    {
//                        let dict = data as! CX_Products
//                        let id = dict.pid
//                        print("ids \(id!)")
//                        }
//        }
//
        
        
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
            cell.viewColor.backgroundColor = UIColor().HexToColor(hexString: self.colorCode.object(at: indexPath.row) as! String, alpha: 1.0)
            cell.viewColor.layer.borderWidth = 1
            cell.viewColor.layer.cornerRadius = 4
            cell.viewColor.layer.borderColor = UIColor.lightGray.cgColor
            cell.checkBtncolor.addTarget(self, action: #selector(FilterViewController.radioBtnTapped(_:)), for: .touchUpInside)
            cell.checkBtncolor.tag = indexPath.row + 100
            let values : String = colorSelectedArr.object(at: indexPath.row) as! String
            if values == "NO"{
                cell.checkBtncolor.setImage(UIImage(named: "uncheckbtn"), for: .normal)
                cell.checkBtncolor.isSelected = false
            }else{
                cell.checkBtncolor.setImage(UIImage(named: "checkBtn"), for: .normal)
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
                    cell.radioButton.setImage(UIImage(named: "uncheckbtn"), for: .normal)
                    cell.radioButton.isSelected = false
                }else{
                    cell.radioButton.setImage(UIImage(named: "checkBtn"), for: .normal)
                    cell.radioButton.isSelected = true
                }
            }else if ageKey == "Age" {
                cell.name.text = self.ageArr.object(at: indexPath.row) as? String
                cell.radioButton.addTarget(self, action: #selector(FilterViewController.radioBtnTapped(_:)), for: .touchUpInside)
                cell.radioButton.tag = indexPath.row + 100
                let values : String = ageSelectedArr.object(at: indexPath.row) as! String
                if values == "NO"{
                    cell.radioButton.setImage(UIImage(named: "uncheckbtn"), for: .normal)
                    cell.radioButton.isSelected = false
                    //
                }else{
                    cell.radioButton.setImage(UIImage(named: "checkBtn"), for: .normal)
                    cell.radioButton.isSelected = true
                }
            }else if discountKey == "Discount"
            {
                cell.name.text = self.discountArr.object(at: indexPath.row) as? String
                cell.radioButton.addTarget(self, action: #selector(FilterViewController.radioBtnTapped(_:)), for: .touchUpInside)
                cell.radioButton.tag = indexPath.row + 100
                let values : String = discountSelectedArr.object(at: indexPath.row) as! String
                if values == "NO"{
                    cell.radioButton.setImage(UIImage(named: "uncheckbtn"), for: .normal)
                    cell.radioButton.isSelected = false
                    //
                }else{
                    cell.radioButton.setImage(UIImage(named: "checkBtn"), for: .normal)
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
            sender.setImage(UIImage(named: "uncheckbtn"), for: .normal)
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
            sender.setImage(UIImage(named: "checkBtn"), for: .normal)
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
