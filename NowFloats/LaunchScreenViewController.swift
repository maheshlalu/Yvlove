//
//  LaunchScreenViewController.swift
//  NowFloats
//
//  Created by Manishi on 10/4/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    var sidePanelDataArr:NSArray!
    var sidePanelDataDict:NSDictionary!
    var sidePanelSingleMallDataDict: NSDictionary!
    
    @IBOutlet weak var launchImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getStores()
        getSingleMall()
        
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        let imgUrl = self.isContansKey(self.sidePanelSingleMallDataDict as NSDictionary, key: "logo") ? (self.sidePanelSingleMallDataDict .value(forKey: "logo") as? String)! : ""
        launchImage.sd_setImage(with: URL(string: imgUrl))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isContansKey(_ responceDic : NSDictionary , key : String) -> Bool{
        let allKeys : NSArray = responceDic.allKeys as NSArray
        return  allKeys.contains(key)
        
    }
    
    func getStores(){
        if CX_Stores.mr_findAll().count != 0{
            let productEn = NSEntityDescription.entity(forEntityName: "CX_Stores", in: NSManagedObjectContext.mr_contextForCurrentThread())
            //Predicate predicateWithFormat:@"SUBQUERY(models, $m, ANY $m.trims IN %@).@count > 0",arrayOfTrims];
            let predicate:NSPredicate =  NSPredicate(format: "itemCode contains[c] %@",CXAppConfig.sharedInstance.getAppMallID())
            let fetchRequest: NSFetchRequest<NSFetchRequestResult>= CX_Stores.mr_requestAllSorted(by: "itemCode", ascending: true)
            fetchRequest.predicate = predicate
            fetchRequest.entity = productEn
            self.sidePanelDataArr = CX_Stores.mr_executeFetchRequest(fetchRequest) as NSArray
            
            let storesEntity : CX_Stores = self.sidePanelDataArr.lastObject as! CX_Stores
            
            self.sidePanelDataDict = CXConstant.sharedInstance.convertStringToDictionary(storesEntity.json!)
            print(sidePanelDataDict)
            
        }
        
    }
    
    func getSingleMall(){
        
        if CX_SingleMall.mr_findAll().count != 0  {
            let appdata:CX_SingleMall = CX_SingleMall.mr_findFirst() as! CX_SingleMall
            self.sidePanelSingleMallDataDict = CXConstant.sharedInstance.convertStringToDictionary(appdata.json!)
            print("\(self.sidePanelSingleMallDataDict)")
            self.getStores()
        }else{
            CXAppDataManager.sharedInstance.getSingleMall({ (isDataSaved) in
                let appdata:CX_SingleMall = CX_SingleMall.mr_findFirst() as! CX_SingleMall
                self.sidePanelSingleMallDataDict = CXConstant.sharedInstance.convertStringToDictionary(appdata.json!)
                print("\(self.sidePanelSingleMallDataDict)")
                self.getStores()
                
            })
        }
    }
}
