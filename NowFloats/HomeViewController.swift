//
//  HomeViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/17/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        //http://storeongo.com:8081/Services/getMasters?type=ProductCategories&mallId=530
    
        //let navDrawer:CCKFNavDrawer = (self.navigationController as? CCKFNavDrawer)!
        //navDrawer.drawerToggle()
        /*
         CCKFNavDrawer* navC = (CCKFNavDrawer*)self.navigationController;
         [navC drawerToggle];
         */
      LoadingView.show("Loading", animated: true)
        CXAppDataManager.sharedInstance.dataDelegate = self
        CXAppDataManager.sharedInstance.getTheStoreCategory()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIS toryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addTheTabBarControllers(){
        
      let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let firstTab : UIViewController!
        //("CX_FeaturedProductsJobs", predicate: NSPredicate(format: "parentID == %@",featureProducts.fID!), ispredicate: true, orederByKey: "")
        if CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProducts", predicate: NSPredicate(), ispredicate: false,orederByKey: "").totalCount == 0{
            firstTab = storyBoard.instantiateViewControllerWithIdentifier("UPDATE") as! UpdatesViewController
            firstTab.title = "UPDATES"
        }else{
            firstTab = storyBoard.instantiateViewControllerWithIdentifier("OFFERS") as! OffersViewController
            firstTab.title = "OFFERS"
        }
        
        let product = storyBoard.instantiateViewControllerWithIdentifier("PRODUCT") as! ProductsViewController
        product.title = "PRODUCTS"
        
        let photos = storyBoard.instantiateViewControllerWithIdentifier("PHOTO") as! PhotosViewController
        photos.title = "PHOTOS"
        
        self.tabBarController?.setViewControllers([firstTab,product,photos], animated: true)

//OFFERS
    }

}

extension HomeViewController :AppDataDelegate {
    
    func completedTheFetchingTheData(sender: CXAppDataManager) {
         self.addTheTabBarControllers()
        LoadingView.hide()
    }
    
}

