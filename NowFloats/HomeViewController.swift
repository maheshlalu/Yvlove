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
        CXAppDataManager.sharedInstance.dataDelegate = self
        CXAppDataManager.sharedInstance.getTheStoreCategory()
    }
    
    func addTheTabBarControllers(){
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let firstTab : UIViewController!
        
        if CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProducts", predicate: NSPredicate(), ispredicate: false,orederByKey: "").totalCount == 0{
            firstTab = storyBoard.instantiateViewController(withIdentifier: "UPDATE") as! UpdatesViewController
            firstTab.title = "UPDATES"
            firstTab.tabBarItem.image = UIImage(named: "updateTabImg")
            
        }else{
            firstTab = storyBoard.instantiateViewController(withIdentifier: "OFFERS") as! OffersViewController
            firstTab.title = "OFFERS"
            firstTab.tabBarItem.image = UIImage(named: "offers")
        }
        
        let product = storyBoard.instantiateViewController(withIdentifier: "PRODUCT") as! ProductsViewController
        product.title = "PRODUCTS"
        product.tabBarItem.image = UIImage(named: "productsImage")
        
        let photos = GalleryTabBarViewController()//storyBoard.instantiateViewController(withIdentifier: "PHOTO") as! PhotosViewController
        photos.title = "PHOTOS"
        
        photos.tabBarItem.image = UIImage(named: "picsImage")//picsImage
        self.tabBarController?.setViewControllers([firstTab,product,photos], animated: true)
        
    }
    
    func cartButtonAction(){
    }
    
    func notificationBellAction(){
    }
    
    func profileToggleAction(){
    }
}

extension HomeViewController :AppDataDelegate {
    func completedTheFetchingTheData(_ sender: CXAppDataManager) {
         self.addTheTabBarControllers()
        LoadingView.hide()
    }
}

