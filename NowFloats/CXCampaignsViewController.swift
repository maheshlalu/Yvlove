//
//  CXCampaignsViewController.swift
//  NowFloats
//
//  Created by Rama on 01/09/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class CXCampaignsViewController: CXViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet var campaignCollectionView: UICollectionView!
    var jobArray = NSArray()
    var campCreatedDateArray = NSArray()
    var imageStr = String()
    var prefJobIdStr = String()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CampaignCollectionViewCell", bundle: nil)
        self.campaignCollectionView.register(nib, forCellWithReuseIdentifier: "CampaignCollectionViewCell")
        // Do any additional setup after loading the view.
        getCampaignIteams()
    }
    
    func getCampaignIteams() {
        /*Campaign:
         http://storeongo.com:8081/Services/getMasters?type=Campaigns&mallId=4724*/
        
        LoadingView.show("Loading", animated: true)

        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Campaigns" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
           // print("print Campaign\(responseDict)")
          
             self.jobArray = responseDict.value(forKey: "jobs") as! NSArray
             print("jobArray \( self.jobArray)")
            self.campaignCollectionView.reloadData()
            CXDataService.sharedInstance.hideLoader()
            LoadingView.hide()
            // self.campCreatedDateArray = responseDict.value(forKey: "createdOn") as! NSArray
        }
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return jobArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CampaignCollectionViewCell", for: indexPath as IndexPath)as! CampaignCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
        cell.layer.masksToBounds = true
        let dict = self.jobArray[indexPath.item] as! NSDictionary
       self.prefJobIdStr = dict.value(forKey: "Campaign_Jobs") as! String
       cell.campNameLbl.text = dict.value(forKey: "Name") as? String
        cell.campCreatedDateLbl.text = dict.value(forKey: "createdOn") as? String
        
        if self.imageStr.isEmpty {
            //cell?.courseImageView.image = UIImage(named: "LoginIcon")
            let img_Url = NSURL(string: imageStr )
            cell.campImgView.contentMode = .scaleAspectFit
            cell.campImgView.setImageWith(img_Url as URL!)
        } else if let img_Url_Str = dict.value(forKey: "image") {
            let img_Url = NSURL(string: img_Url_Str as! String )
            cell.campImgView.contentMode = .scaleAspectFit
            cell.campImgView.setImageWith(img_Url as URL!)
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //screenWidth =  UIScreen.main.bounds.size.width
        //return CGSize(width: self.view.frame.size.width/2-9, height: 150)
        return CGSize(width: self.view.frame.size.width/2-8, height: 222)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
         let campaignDetails = storyBoard.instantiateViewController(withIdentifier: "CAMPAIGNSDETAIL") as! CXCampaignDetailViewController
        let dict = self.jobArray[indexPath.item] as! NSDictionary
        campaignDetails.prefferedJodIdsStr = dict.value(forKey: "Campaign_Jobs") as! String
        campaignDetails.productString =  dict.value(forKey: "Name") as? String
         self.navigationController?.pushViewController(campaignDetails, animated: true)
    }
    
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        return true
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        return true
    }
    
    override  func shouldShowCart() -> Bool{
        return true
    }
    
    override func headerTitleText() -> String{
        return "Campaigns"
    }
    
    override func shouldShowLeftMenu() -> Bool{
        return false
    }
    
    override func shouldShowLeftMenuWithLogo() -> Bool{
        return false
    }
    
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    
    override func profileDropdown() -> Bool{
        return false
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }

    
}
