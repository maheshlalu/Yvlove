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
    var selectedIndex:NSIndexPath?
    var selectedArr = NSMutableArray()
    var totalArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.totalArr = ["200 - 400","400 - 600","600 - 800","800 - 1000","1000 - 1200","1200 - 1400","1400 - 1600"]
        
       self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255.0, green: 145/255.0, blue: 0/255.0, alpha: 1.0)
        self.navigationItem.title = "Filter's Selection"
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        let nib = UINib(nibName: "customcellFilter", bundle: nil)
        self.filterTableView.register(nib, forCellReuseIdentifier: "Cell")
//        let colorNib = UINib(nibName: "colortableviewcell", bundle: nil)
//        self.filterTableView.register(colorNib, forCellReuseIdentifier: "CellColor")
        
        for _ in 0 ..< self.totalArr.count {
            (selectedArr as AnyObject).add("NO")
        }
        //print("selected \(selectedArr)")
//        self.navigationController?.navigationBar.isHidden = true

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
       return self.totalArr.count
    }
    func numberOfSections(in tableView: UITableView) -> Int{
        
       return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
      
        let cell:customcellFilter = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! customcellFilter
        
        cell.name.text = self.totalArr.object(at: indexPath.row) as? String
        //cell.radioButton.setImage(UIImage(named: "uncheckbtn"), for: .normal)
        cell.radioButton.tag = indexPath.row + 100
        cell.radioButton.addTarget(self, action: #selector(FilterViewController.radioBtnTapped(_:)), for: .touchUpInside)
 
       // cell.radioButton.tag = indexPath.row + 100
        
        let values : String = selectedArr.object(at: indexPath.row) as! String
        if values == "NO"{
            cell.radioButton.setImage(UIImage(named: "uncheckbtn"), for: .normal)
        cell.radioButton.isSelected = false
        
        }else{
            cell.radioButton.setImage(UIImage(named: "checkbtn"), for: .normal)
            cell.radioButton.isSelected = true
        }
        
            return cell
    
    }
    func radioBtnTapped(_ sender: UIButton)
    {
        
        if sender.isSelected {
            sender.isSelected = false
            selectedArr.replaceObject(at: sender.tag - 100, with: "YES")
            sender.setImage(UIImage(named: "uncheckbtn"), for: .normal)
            //sender.setImage("checkBtn", for: UIControlState.normal)
        }else{
            sender.isSelected = true
            selectedArr.replaceObject(at: sender.tag - 100, with: "NO")
            sender.setImage(UIImage(named: "checkBtn"), for: .normal)
            
        
        }
       // self.filterTableView.reloadData()
    
    
    }
    //MARK: Price action
    @IBAction func priceBtnTapped(_ sender: Any) {
        self.totalArr = ["200 - 400","400 - 600","600 - 800","800 - 1000","1000 - 1200","1200 - 1400","1400 - 1600"]
        self.selectedArr = NSMutableArray()
        for _ in 0 ..< self.totalArr.count {
            (selectedArr as AnyObject).add("NO")
        }
       // print("selected \(selectedArr)")
        self.filterTableView.reloadData()
        
    }
    //MARK: Age action
    @IBAction func agebtnTapped(_ sender: Any) {
         self.totalArr = ["10 - 15","15 - 20","20 - 25","25 - 35","35 - 60",]
        self.selectedArr = NSMutableArray()
        for _ in 0 ..< self.totalArr.count {
            (selectedArr as AnyObject).add("NO")
        }
       // print("selected \(selectedArr)")
        self.filterTableView.reloadData()
        
    }
    //MARK: Discount action
    @IBAction func discountBtnTapped(_ sender: Any) {
        self.totalArr = ["2%","5%","10%","15%","30%"]
            
        self.selectedArr = NSMutableArray()
        for _ in 0 ..< self.totalArr.count {
            (selectedArr as AnyObject).add("NO")
        }
       // print("selected \(selectedArr)")
        self.filterTableView.reloadData()
        
    }
    //MARK: Color action
    @IBAction func colorBtnTapped(_ sender: Any) {
        self.totalArr = ["Red","Blue","Yellow","Green","Pink"]
        
        self.selectedArr = NSMutableArray()
        for _ in 0 ..< self.totalArr.count {
            (selectedArr as AnyObject).add("NO")
        }
        //print("selected \(selectedArr)")
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
