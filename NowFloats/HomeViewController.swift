//
//  HomeViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/17/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.greenColor()
       // self.setUpPagerDelegate()
       // self.setUpPager()
        // Do any additional setup after loading the view.
    }

    //MARK: Setup PagerDelegate
    func setUpPagerDelegate(){
       
        
    }
    
    func setUpTabBarController(){
        
        
    }
    
   /* func setUpPager(){
        
        let updates : UpdatesViewController = UpdatesViewController(nibName: "UpdatesViewController", bundle: nil)
        let products : ProductsViewController = ProductsViewController(nibName: "ProductsViewController", bundle: nil)
        let photos : PhotosViewController = PhotosViewController(nibName: "PhotosViewController", bundle: nil)

        
        let tabNames : NSMutableArray = ["UPDATES","PRODUCTS","PHOTOS"]
        let viewControllers : NSMutableArray = [updates,products,photos]
        let tabcontrl : NSMutableArray = NSMutableArray()
        
        
        for (index,tabName) in tabNames.enumerate() {
            let adPageCntl :ADPageModel = ADPageModel()
            adPageCntl.strPageTitle = tabName as! String
            adPageCntl.iPageNumber = Int32(index)
            adPageCntl.viewController = viewControllers[index] as! UIViewController
            adPageCntl.bShouldLazyLoad = true
            tabcontrl.addObject(adPageCntl)
        }
        
        let pageControl : ADPageControl = ADPageControl(nibName: "ADPageControl", bundle: nil)
        //pageControl.delegateADPageControl = self
        pageControl.arrPageModel = tabcontrl
        pageControl.iFirstVisiblePageNumber = 0
        pageControl.iTitleViewHeight = 50
        pageControl.iPageIndicatorHeight = 4
        pageControl.fontTitleTabText = UIFont.boldSystemFontOfSize(14)
        pageControl.bEnablePagesEndBounceEffect = false
        pageControl.bEnableTitlesEndBounceEffect = false
        pageControl.bShowMoreTabAvailableIndicator = false
        
        pageControl.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)
        self.view.addSubview(pageControl.view)
        
      
    }
    */

    
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

}

