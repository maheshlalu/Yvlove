//
//  GalleryTabBarViewController.swift
//  NowFloats
//
//  Created by Manishi on 2/3/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class GalleryTabBarViewController: UIViewController,CAPSPageMenuDelegate{
    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabViews()
    }
    
    func tabViews(){
        var controllerArray : [UIViewController] = []
        //storyBoard.instantiateViewController(withIdentifier: "PHOTO") as! PhotosViewController
        let controller1:PhotosViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PHOTO") as! PhotosViewController
        let nav : UINavigationController = UINavigationController(rootViewController: controller1)
        controller1.title = "Gallery"
        nav.isNavigationBarHidden = true
        controllerArray.append(nav)
        
        let controller2 : PhotosViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PHOTO") as! PhotosViewController
        let nav1 : UINavigationController = UINavigationController(rootViewController: controller2)
        controller2.title = "Videos"
        nav1.isNavigationBarHidden = true
        controllerArray.append(nav1)
        
        let controller3 : PhotosViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PHOTO") as! PhotosViewController
        let nav3 : UINavigationController = UINavigationController(rootViewController: controller3)
        controller3.title = "Videos"
        nav3.isNavigationBarHidden = true
        controllerArray.append(nav3)
        
        let parameters: [CAPSPageMenuOption] = [
            .selectionIndicatorColor(UIColor.white),
            .selectedMenuItemLabelColor(UIColor.white),
            .menuItemFont(UIFont(name: "Roboto-Bold", size: 15.0)!),
            .scrollMenuBackgroundColor(CXAppConfig.sharedInstance.getAppTheamColor()),
            .useMenuLikeSegmentedControl(true)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)
    }
}
