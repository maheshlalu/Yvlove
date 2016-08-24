//
//  HomeViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/17/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        //http://storeongo.com:8081/Services/getMasters?type=ProductCategories&mallId=530
        
        print(CXAppConfig.sharedInstance.getSidePanelList())
        CXDataService.sharedInstance.getTheAppDataFromServer(["type": "ProductCategories","mallId": CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
            print(responseDict)
        }
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

}

