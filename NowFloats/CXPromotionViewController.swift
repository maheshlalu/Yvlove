//
//  CXPromotionViewController.swift
//  NowFloats
//
//  Created by Rama on 06/09/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class CXPromotionViewController: UIViewController {

    var videoPlayer: YouTubePlayerView!
    var youtubeVideoUrl : String!
    var bannerImg = UIImageView()
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var headerView: UIView!
     var imgArr:NSMutableArray = NSMutableArray()
     var youTubeURLArray:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPromotionalApi()
    }
    
    @IBAction func backAction(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
    }
     func getPromotionalApi()  {
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Interstitial Promotions" as AnyObject,"mallId":"4724" as AnyObject]) { (responseDict) in
            let promoArr = responseDict.value(forKey: "jobs") as! NSArray
            
            print("promotionArray \(promoArr)")
            for promoData in promoArr{
                let dict:NSDictionary = promoData as! NSDictionary
                let imgActivity = dict.value(forKey: "Image_URL") as! String
                self.imgArr.add(imgActivity)
                let urlActivity = dict.value(forKey: "YouTube URL") as! String
                self.youTubeURLArray.add(urlActivity)
            }
            CXLog.print("ALL imgArr== \(self.imgArr)")
            CXLog.print("ALL youTubeArr== \(self.youTubeURLArray)")

            if (self.youTubeURLArray.count>0){
                self.createPlayerView()
            }else{
                 self.createImageView()
            }
        }
    }
    func getimgUrl() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(self.imgArr.count)))
        return self.imgArr[randomIndex] as! String
    }
    func getYouTubeUrl() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(self.youTubeURLArray.count)))
        return self.youTubeURLArray[randomIndex] as! String
    }
    func createPlayerView(){
        self.videoPlayer = YouTubePlayerView()
        self.headerView.backgroundColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.videoPlayer.frame = CGRect(x: 0, y:
            30, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height)
        
        let youTubeStr = getYouTubeUrl()
        if youTubeStr .isEmpty{
             self.createImageView()
        }else{
            self.videoPlayer.loadVideoURL(NSURL(string: youTubeStr)! as URL)
        }
       // self.videoPlayer.loadVideoURL(NSURL(string: youTubeStr)! as URL)
        self.backgroundView.addSubview(self.videoPlayer)
    }
    func createImageView(){
        let imgStr = getimgUrl()
        let img_Url = NSURL(string: imgStr)
        bannerImg.contentMode = .scaleAspectFit
        bannerImg.sd_setImage(with: img_Url! as URL)
        bannerImg.frame = CGRect(x: 0, y: 30, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height)
        self.headerView.backgroundColor = UIColor.white
        self.backgroundView.addSubview(bannerImg)
    }
}
