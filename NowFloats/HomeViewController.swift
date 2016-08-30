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
        
        
        CXAppDataManager.sharedInstance.getTheStoreCategory()
        self.addTheTabBarControllers()
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

       
        

        let offers = storyBoard.instantiateViewControllerWithIdentifier("UPDATE") as! UpdatesViewController
        offers.title = "OFFERS"
        let product = storyBoard.instantiateViewControllerWithIdentifier("PRODUCT") as! ProductsViewController
        product.title = "PRODUCTS"
        
        let photos = storyBoard.instantiateViewControllerWithIdentifier("PHOTO") as! PhotosViewController
        photos.title = "PHOTOS"
        
        self.tabBarController?.setViewControllers([offers,product,photos], animated: true)


    }

}

