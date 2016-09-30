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
      //LoadingView.show("Loading", animated: true)
        CXAppDataManager.sharedInstance.dataDelegate = self
        
        
//        for item in self.tabBar.items as UITabBarItem
//        {
//            item.image = item.selectedImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//            item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.darkGrayColor()], forState:UIControlState.Normal)
//            item.setTitleTextAttributes([NSForegroundColorAttributeName: CXAppConfig.sharedInstance.getAppTheamColor()], forState:UIControlState.Selected)
//        }
//        
        CXAppDataManager.sharedInstance.getTheStoreCategory()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTheTabBarControllers(){

      let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let firstTab : UIViewController!

        if CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProducts", predicate: NSPredicate(), ispredicate: false,orederByKey: "").totalCount == 0{
            firstTab = storyBoard.instantiateViewControllerWithIdentifier("UPDATE") as! UpdatesViewController
            firstTab.title = "UPDATES"
            firstTab.tabBarItem.image = UIImage(named: "updateTabImg")

        }else{
            firstTab = storyBoard.instantiateViewControllerWithIdentifier("OFFERS") as! OffersViewController
            firstTab.title = "OFFERS"
            firstTab.tabBarItem.image = UIImage(named: "offers")
        }
        
        let product = storyBoard.instantiateViewControllerWithIdentifier("PRODUCT") as! ProductsViewController
        product.title = "PRODUCTS"
        product.tabBarItem.image = UIImage(named: "productsImage")
        
        let serviceForm : ServiceFormViewController = ServiceFormViewController()
        serviceForm.title = "Form"


        let photos = storyBoard.instantiateViewControllerWithIdentifier("PHOTO") as! PhotosViewController
        photos.title = "PHOTOS"
        photos.tabBarItem.image = UIImage(named: "picsImage")//picsImage
        
        self.tabBarController?.setViewControllers([firstTab,product,photos,serviceForm], animated: true)

//OFFERS
    }
    
    func cartButtonAction(){
        
        
    }
    
    func notificationBellAction(){
        
    }
    
    func profileToggleAction(){
        
    }
    

}

extension HomeViewController :AppDataDelegate {
    
    func completedTheFetchingTheData(sender: CXAppDataManager) {
         self.addTheTabBarControllers()
        LoadingView.hide()
    }
    
}

