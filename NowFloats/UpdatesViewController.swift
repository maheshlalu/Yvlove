//
//  UpdatesViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/18/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class UpdatesViewController: CXViewController {
    
    @IBOutlet weak var offersNotAvailLbl: UILabel!
    let monthsMillisecond:Int64 = 2592000000
    @IBOutlet weak var updateTableView: UITableView!
    @IBOutlet weak var updatesSearch: UISearchBar!
    var updatesArray : NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTableView.backgroundView?.backgroundColor = UIColor.clear
        self.updateTableView.backgroundColor = UIColor.clear
        self.view.backgroundColor =  CXAppConfig.sharedInstance.getAppBGColor()
        self.offersNotAvailLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.setUpTableView()
        self.getUpdates()
    }
    
    func getUpdates(){
        
        CXAppDataManager.sharedInstance.getUpdates { (response) in
            self.updatesArray = response
            if self.updatesArray.count == 0{
                self.offersNotAvailLbl.isHidden = false
                self.updateTableView.isHidden = true
                self.updatesSearch.isHidden = true
            }else{
                self.offersNotAvailLbl.isHidden = true
                self.updateTableView.isHidden = false
                self.updatesSearch.isHidden = false
            }
            
            self.updateTableView.reloadData()
        }
        
    }
    
    func setUpTableView(){
        let nib = UINib(nibName: "UpdateTableViewCell", bundle: nil)
        self.updateTableView.register(nib, forCellReuseIdentifier: "UpdateTableViewCell")
        self.updateTableView.rowHeight = UITableViewAutomaticDimension
        self.updateTableView.estimatedRowHeight = 10.0
        //self.tableview.contentInset = UIEdgeInsetsMake(0,5, 0,5)
        self.updateTableView.delegate =  self
        self.updateTableView.dataSource = self
    }
}

extension UpdatesViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int{
        return self.updatesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 7.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        self.updateTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateTableViewCell", for: indexPath)as! UpdateTableViewCell
        //cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView?.backgroundColor = UIColor.clear
        let updateDic : NSDictionary = self.updatesArray[indexPath.section] as! NSDictionary
        cell.selectionStyle = .none
        cell.descriptionLabel.text = updateDic.value(forKey: "Feed") as?String
        
        let createdDate = updateDic.value(forKey: "createdOn") as? String
        let createdTimeStr = getCreatedTime(createdDate!)
        cell.monthLabel.text = createdTimeStr
        
        
        let imgUrl = updateDic.value(forKey: "Image") as?String
        if (imgUrl!.lowercased().range(of: "https") != nil){
            cell.nameimageView.sd_setImage(with: URL(string:imgUrl!))
        }
        cell.shareBtn.tag = indexPath.section+1
        cell.shareBtn.addTarget(self, action: #selector(UpdatesViewController.shareBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.descriptionLabel.font = CXAppConfig.sharedInstance.appMediumFont()
        cell.monthLabel.font = CXAppConfig.sharedInstance.appSmallFont()

        return cell
    }
    
    func shareBtnAction(_ button : UIButton!){
        let updateDic : NSDictionary = self.updatesArray[button.tag-1] as! NSDictionary
        let description = updateDic.value(forKey: "Feed") as?String
        let url = updateDic.value(forKey: "publicURL") as? String
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [description!,url!], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func getCreatedTime(_ createdDate:String) -> String{
        let component = createdDate.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let list = component.filter({ $0 != "" })
        let number: Int64? = Int64(list[0])
        
        let mydate = Date()
        let currentTime = Int64(mydate.timeIntervalSince1970 * 1000)
        
        let finalDate = currentTime - number!
        
        var milliseconds : double_t = double_t(finalDate);
        
        milliseconds =  floor(milliseconds/1000);
        let seconds = milliseconds //29825913.019
        let minutes = floor(milliseconds/60) //497098.55031667
        let hours = floor(minutes/60) //8284.9758386111661821
        let days = floor(hours/24) //345.20732660879860987
        let weeks = floor(days/7) //49.31533237268551062
        let months = finalDate/monthsMillisecond
        let years = months/12
        
        if years == 0 {
            return "\(months) Months Ago"
        }else if months == 0 {
            return "\(weeks) Weeks Ago"
        }else if weeks == 0 {
            return "\(days) Days Ago"
        }else if days == 0 {
            return "\(hours) Hours Ago"
        }else if hours == 0 {
            return "\(minutes) Minutes Ago"
        }else if minutes == 0 {
            return "\(seconds) Seconds Ago"
        }
        return ""
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension UpdatesViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar){
        self.updatesSearch.resignFirstResponder()
        //self.doSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if (self.updatesSearch.text!.characters.count > 0) {
            //self.doSearch()
        } else {
            self.loadDefaultList()
        }
        
    }
    
    func loadDefaultList (){
        self.getUpdates()
        /*if isProductCategory {
         let predicate:NSPredicate = NSPredicate(format: "masterCategory = %@", "Products List(129121)")
         self.getProductSubCategory(predicate)
         }else{
         let predicate:NSPredicate = NSPredicate(format: "masterCategory = %@", "Miscellaneous(135918)")
         self.getProductSubCategory(predicate)
         }*/
    }
    
    func refreshSearchBar (){
        self.updatesSearch.resignFirstResponder()
        // Clear search bar text
        self.updatesSearch.text = "";
        // Hide the cancel button
        //eself.updatesSearch.showsCancelButton = false;
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.refreshSearchBar()
        // Do a default fetch of the beers
        self.loadDefaultList()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.updatesSearch.showsCancelButton = false;
    }
    
    func doSearch(){
        let productEn = NSEntityDescription.entity(forEntityName: "CX_Products", in: NSManagedObjectContext.mr_contextForCurrentThread())
        let predicate:NSPredicate =  NSPredicate(format: "name contains[c] %@",self.updatesSearch.text!)
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CX_Products.mr_requestAllSorted(by: "pid", ascending: false)
        fetchRequest.predicate = predicate
        fetchRequest.entity = productEn
        self.updatesArray = CX_Products.mr_executeFetchRequest(fetchRequest) as NSArray

        self.updateTableView.reloadData()
        
        /*let productEn = NSEntityDescription.entityForName("TABLE_PRODUCT_SUB_CATEGORIES", inManagedObjectContext: NSManagedObjectContext.MR_contextForCurrentThread())
         let fetchRequest = TABLE_PRODUCT_SUB_CATEGORIES.MR_requestAllSortedBy("id", ascending: false)
         var predicate:NSPredicate = NSPredicate()
         
         if isProductCategory {
         predicate = NSPredicate(format: "masterCategory = %@ AND name contains[c] k%@", "Products List(129121)",self.searchBar.text!)
         }else{
         predicate = NSPredicate(format: "masterCategory = %@ AND name contains[c] %@", "Miscellaneous(135918)",self.searchBar.text!)
         }
         
         fetchRequest.predicate = predicate
         fetchRequest.entity = productEn
         
         self.productCategories =   TABLE_PRODUCT_SUB_CATEGORIES.MR_executeFetchRequest(fetchRequest)
         
         self.productCollectionView.reloadData()*/
        
    }
}
