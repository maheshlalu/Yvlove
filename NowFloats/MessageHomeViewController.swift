//
//  MessageHomeViewController.swift
//  NowFloats
//
//  Created by Manishi on 9/20/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit


class MessageHomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addTheTabBarControllers()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTheTabBarControllers(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    
        let product = storyBoard.instantiateViewControllerWithIdentifier("FORM") as! FormViewController
        //product.title = "PRODUCTS"
        //product.tabBarItem.image = UIImage(named: "productsImage")
        
        
        let photos = storyBoard.instantiateViewControllerWithIdentifier("HISTORY") as! HistoryViewController
        //photos.title = "PHOTOS"
        //photos.tabBarItem.image = UIImage(named: "picsImage")//picsImage
        
        self.tabBarController?.setViewControllers([product,photos], animated: true)
        
        //OFFERS
    }

}
