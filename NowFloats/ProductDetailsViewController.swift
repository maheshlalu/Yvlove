//
//  ProductDetailsViewController.swift
//  NowFloats
//
//  Created by Manishi on 9/9/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var productDetailsTableView: UITableView!
    var productString : String!
    var productDetailDic:NSDictionary!
    
    @IBOutlet weak var placeOrderBtn: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productDetailsTableView.rowHeight = UITableViewAutomaticDimension
        self.productDetailsTableView.estimatedRowHeight = 10.0
        self.productDetailsTableView.separatorStyle = .None
        print(CXConstant.sharedInstance.convertStringToDictionary(productString))
        productDetailDic = CXConstant.sharedInstance.convertStringToDictionary(productString)
        print("\(productDetailDic)")
        print("\(productDetailDic.valueForKey("Description"))")
        /*[createdOn, hrsOfOperation, id, P3rdCategory, Name, Large_Image, publicURL, Current_Job_StatusId, Brand, jobTypeName, Category, Insights, guestUserEmail, Next_Seq_Nos, SubCategoryType, jobComments, PackageName, Image_URL, Current_Job_Status, Next_Job_Statuses, ItemCode, Description, Additional_Details, DiscountAmount, Image_Name, overallRating, CreatedSubJobs, Category_Mall, Quantity, Attachments, MRP, guestUserId, totalReviews, lastModifiedDate, createdByFullName, createdById, CategoryType, jobTypeId]*/

    }
    func customisingBtns(){
    
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 4
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell? = nil
        
        if indexPath.section == 0{
            let imageCellIdentifier = "ImageCell"
            cell = tableView.dequeueReusableCellWithIdentifier(imageCellIdentifier)!
            cell?.selectionStyle = .None
            
            let productImageView = cell!.contentView.viewWithTag(100)! as! UIImageView
            let imgUrl = productDetailDic.valueForKey("Image_URL") as! String
            productImageView.sd_setImageWithURL(NSURL(string: imgUrl))
            
            
        }else if indexPath.section == 1{
            let headerCellIdentifier = "Headercell"
            cell = tableView.dequeueReusableCellWithIdentifier(headerCellIdentifier)!
            cell?.selectionStyle = .None
            
            let finalPriceLbl = (cell!.viewWithTag(1)! as! UILabel)
            let discountPriceLbl = cell?.viewWithTag(300)! as! UILabel
            let discountPersentageLbl = cell?.viewWithTag(400)! as! UILabel
            
            let rupee = "\u{20B9}"
            let price:String = productDetailDic.valueForKey("MRP") as! String
            let discount:String = productDetailDic.valueForKey("DiscountAmount") as! String
            
            if discount == "0"{
                discountPriceLbl.hidden = true
                discountPersentageLbl.hidden = true
                finalPriceLbl.text = "\(rupee) \(price)"
            }else{
                discountPriceLbl.hidden = false
                discountPersentageLbl.hidden = false
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(rupee) \(price)")
                attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                discountPriceLbl.attributedText = attributeString
                
                
                let finalPriceNum:Int = Int(price)!-Int(discount)!
                finalPriceLbl.text = "\(rupee) \(String(finalPriceNum))"
                
//                let discountPersnt:Float = Float(25000)/Float(22000)
//                let finalDiscount:Float = discountPersnt*100
//                
//                discountPersentageLbl.text = "\(finalDiscount)%"
                
                
            }
            
        }else if indexPath.section == 2{
            let productInfoIdentifier = "ProductInfoCell"
            cell = tableView.dequeueReusableCellWithIdentifier(productInfoIdentifier)!
            cell?.selectionStyle = .None
            let textView = (cell!.viewWithTag(6)! as! UITextView)
            
            textView.text = "\(productDetailDic.valueForKey("Description")!)"
            
        }else if indexPath.section == 3{
            let footerIdentifier = "FooterCell"
            cell = tableView.dequeueReusableCellWithIdentifier(footerIdentifier)!
            cell?.selectionStyle = .None
            
          //  let shipmentLbl =
        }
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        return UITableViewAutomaticDimension
        
    }
}
