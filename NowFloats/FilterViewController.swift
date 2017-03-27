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
    
    var ageArr = NSMutableArray()
    var ageSelectedArr = NSMutableArray()
    var ageKey = NSString()
    
    var discountArr = NSMutableArray()
    var discountSelectedArr = NSMutableArray()
    var discountKey = NSString()
    
    var colorArr = NSMutableArray()
    var colorSelectedArr = NSMutableArray()
    var colorKey = NSString()
    var colorKeyword = NSString()
    var products = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Price
        self.priceKey = "Price"
        self.priceArr = ["50 - 100","100 - 150","150 - 200","200 - 250","300 - 350","350 - 450"]
        for _ in 0 ..< self.priceArr.count {
            (priceSelectedArr as AnyObject).add("NO")
        }
        // age
        self.ageKey = "Age"
        self.ageArr = ["2 - 5","6 - 8","9 - 16","10 - 20","21 - 30",]
        for _ in 0 ..< self.ageArr.count {
            (ageSelectedArr as AnyObject).add("NO")
        }
        //Discount
        self.discountKey = "Discount"
        self.discountArr = ["2%","5%","10%","15%","30%"]
        for _ in 0 ..< self.discountArr.count {
            (discountSelectedArr as AnyObject).add("NO")
        }
        // color
        self.colorKey = "ColorWord"
        self.colorArr = ["Red","Blue","Yellow","Green","Pink"]
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
            
            cell.checkBtncolor.addTarget(self, action: #selector(FilterViewController.radioBtnTapped(_:)), for: .touchUpInside)
            
            cell.checkBtncolor.tag = indexPath.row + 100
            
            let values : String = colorSelectedArr.object(at: indexPath.row) as! String
            if values == "NO"{
                cell.checkBtncolor.setImage(UIImage(named: "uncheckbtn"), for: .normal)
                cell.checkBtncolor.isSelected = false
                //
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
                    //
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
            //cell.name.text = self.priceArr.object(at: indexPath.row) as? String
            //  cell.radioButton.setImage(UIImage(named: "uncheckbtn"), for: .normal)
            //cell.radioButton.tag = indexPath.row + 100
            
            return cell
        }
        
        
    }
    func radioBtnTapped(_ sender: UIButton)
    {
        
        if sender.isSelected {
            sender.isSelected = false
            // selectedArr.replaceObject(at: sender.tag - 100, with: "YES")
            sender.setImage(UIImage(named: "uncheckbtn"), for: .normal)
            if priceKey == "Price"{
                priceSelectedArr.replaceObject(at: sender.tag - 100, with: "NO")
            }else if ageKey == "Age" {
                ageSelectedArr.replaceObject(at: sender.tag - 100, with: "NO")
            }else if discountKey == "Discount"
            {
                discountSelectedArr.replaceObject(at: sender.tag - 100, with: "NO")
            }else if colorKeyword == "ColorWord"{
                
                colorSelectedArr.replaceObject(at: sender.tag - 100, with: "NO")
            }
            
            //sender.setImage("checkBtn", for: UIControlState.normal)
        }else{
            sender.isSelected = true
            // selectedArr.replaceObject(at: sender.tag - 100, with: "NO")
            sender.setImage(UIImage(named: "checkBtn"), for: .normal)
            if priceKey == "Price"{
                priceSelectedArr.replaceObject(at: sender.tag - 100, with: "YES")
            }else if ageKey == "Age" {
                ageSelectedArr.replaceObject(at: sender.tag - 100, with: "YES")
            }else if discountKey == "Discount"
            {
                discountSelectedArr.replaceObject(at: sender.tag - 100, with: "YES")
            }else if colorKeyword == "ColorWord"{
                
                colorSelectedArr.replaceObject(at: sender.tag - 100, with: "YES")
            }
            
            let fetchRequest :  NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CX_Products")
            let str = "purple"
            let predicate =  NSPredicate(format: "metaData CONTAINS[c] %@" , argumentArray: [str])
            
        
            fetchRequest.predicate = predicate
            let arr:NSArray  =  CX_Products.mr_findAll(with: predicate) as NSArray
            for data in arr
            {
            let dict = data as! CX_Products
                let id = dict.pid
                print("ids \(id)")
                
            
            
            }
            //print("product is \(arr)")
            
            //let resultstr =  str.replacingOccurrences(of: " ", with: "")
            
//            let predicate =  NSPredicate(format: "type=='\("yellow")'", argumentArray: nil)
//            fetchRequest.predicate = predicate
//            let arr:NSArray  =  CX_Products.mr_executeFetchRequest(fetchRequest) as NSArray!
//            print(arr.count)

            
        }
        // self.filterTableView.reloadData()
        
        
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
  

    
    // save selected items in local
    //func savelocal

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
