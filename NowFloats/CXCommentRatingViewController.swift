//
//  CXCommentRatingViewController.swift
//  Silly Monks
//
//  Created by NUNC on 5/23/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CXCommentRatingViewController: CXViewController,FloatRatingViewDelegate,UITextViewDelegate {

    var ratingLabel:UILabel!
    var floatRatingView: FloatRatingView!
    var commentsView:UITextView!
    var cScrollView:UIScrollView!
    var jobID : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor()
        self.customizeMainView()

    }
    
    
    func customizeMainView() {
        self.cScrollView = UIScrollView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-65))
        self.view.addSubview(self.cScrollView)
        
        let labelText = UILabel.init(frame: CGRectMake(5, 0, (self.cScrollView.frame.size.width/2)-10, 45))
        labelText.text = "YOUR RATING"
        labelText.font = UIFont(name: "Roboto-Regular", size:15)
        labelText.textAlignment = NSTextAlignment.Left
        self.cScrollView.addSubview(labelText)
        
        self.ratingLabel = UILabel.init(frame: CGRectMake(labelText.frame.size.width+labelText.frame.origin.x+5, 0, (self.cScrollView.frame.size.width/2)-10, 45))
        self.ratingLabel.text = "0.0"
        self.ratingLabel.font = UIFont(name: "Roboto-Regular",size: 15)
        self.ratingLabel.textAlignment = NSTextAlignment.Right
        self.cScrollView.addSubview(self.ratingLabel)
        
        let ratWidth  = self.cScrollView.frame.size.width/2
        
        self.floatRatingView = self.customizeRatingView(CGRectMake((self.cScrollView.frame.size.width-ratWidth)/2, self.ratingLabel.frame.size.height+self.ratingLabel.frame.origin.y,ratWidth, 40))
        self.floatRatingView.backgroundColor = UIColor.clearColor()
        self.cScrollView.addSubview(self.floatRatingView)
        
        self.commentsView = UITextView.init(frame: CGRectMake(5, self.floatRatingView.frame.size.height+self.floatRatingView.frame.origin.y, self.cScrollView.frame.size.width-10, 220))
        self.commentsView.delegate = self
        self.commentsView.font = UIFont(name: "Roboto-Regular", size: 15)
        self.commentsView.text = "Wrire at least 50 characters"
        self.commentsView.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.commentsView.layer.borderWidth = 1
        self.cScrollView.addSubview(self.commentsView)
        self.addAccessoryViewToField(self.commentsView)
        
        let submitBtn = UIButton.init(frame: CGRectMake(10, self.commentsView.frame.size.height+self.commentsView.frame.origin.y+10, self.cScrollView.frame.size.width-20, 40))
        submitBtn.setTitle("Submit", forState: UIControlState.Normal)
        submitBtn.backgroundColor = UIColor.darkGrayColor()
        submitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        submitBtn.addTarget(self, action: #selector(CXCommentRatingViewController.submitAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.cScrollView.addSubview(submitBtn)
    }
    
    func submitAction() {
        if self.commentsView.text != nil {
            if self.commentsView.text.characters.count < 50 {
                self.showAlertView("Please enter at least 50 characters.", status: 0)
            }else{
               // self.submitTheComments()
            }
        }
    }
    
    func showAlertView(message:String, status:Int) {
        let alert = UIAlertController(title: "Silly Monks", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        //alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            if status == 1 {
                //self.navigationController?.popViewControllerAnimated(true)
            }
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }


    func customizeRatingView(frame:CGRect) -> FloatRatingView {
        let ratView : FloatRatingView = FloatRatingView.init(frame: frame)
        
        ratView.emptyImage = UIImage(named: "star_unsel_108.png")
        ratView.fullImage = UIImage(named: "star_sel_108.png")
        // Optional params
        ratView.delegate = self
        ratView.contentMode = UIViewContentMode.ScaleAspectFit
        ratView.maxRating = 5
        ratView.minRating = 0
        ratView.rating = 0
        ratView.editable = true
        ratView.halfRatings = true
        ratView.floatRatings = false
        
        return ratView
    }
    
    func addAccessoryViewToField(mTextView:UITextView) {
        let numToolBar = UIToolbar.init(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        numToolBar.barStyle = UIBarStyle.BlackTranslucent
        let clearBtn = UIBarButtonItem.init(title: "Clear", style: UIBarButtonItemStyle.Bordered, target: self, action: #selector(CXCommentRatingViewController.clearNumPadAction))
        let flexSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action:nil)
        let doneBtn = UIBarButtonItem.init(title:"Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(CXCommentRatingViewController.doneNumberPadAction))
        
        numToolBar.items = [clearBtn,flexSpace,doneBtn]
        numToolBar.sizeToFit()
        mTextView.inputAccessoryView = numToolBar
    }
    
    func doneNumberPadAction() {
        self.view.endEditing(true)
    }
    //MARK: Submit the comment
    
        func commentSubiturl(userID:String, jobID:String,comment:String,rating:String,commentId:String) ->String{
    
            //let escapedString = productType.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            let reqString = "http://sillymonksapp.com:8081/jobs/saveJobCommentJSON?userId="+userID+"&jobId="+jobID+"&comment="+comment+"&rating="+rating+"&commentId="+commentId
            //http://sillymonksapp.com:8081/jobs/saveJobCommentJSON?/ userId=11&jobId=239&comment=excellent&rating=0.5&commentId=74
            return reqString
        }

    func submitTheComments(){
        /*
         return getHostUrl(mContext) + "/jobs/saveJobCommentJSON?";
         / userId=11&jobId=239&comment=excellent&rating=0.5&commentId=74 /
         
        
         */
        

    }
    
    func clearNumPadAction() {
        self.view.endEditing(true)
        self.commentsView.text = nil
    }


    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        //ratingView.rating = 0
//        let signInView = CXSignInSignUpViewController.init()
//        self.navigationController?.pushViewController(signInView, animated: true)
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        //ratingView.rating = 0
        self.ratingLabel.text = NSString(format: "%.1f", self.floatRatingView.rating) as String
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Wrire at least 50 characters" {
            textView.text = ""
        }
        
        let scrollPoint = CGPointMake(0, textView.frame.origin.y)
        self.cScrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.text = textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if textView.text == nil {
            textView.text = "Wrire at least 50 characters"
        }
        self.cScrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.contentOffset = CGPointMake(0.0, textView.contentSize.height)
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
//        let line : CGRect = textView.caretRectForPosition((textView.selectedTextRange?.start)!)
//        let overFlow: CGFloat = (line.origin.y + line.size.height) - ((textView.contentOffset.y + textView.bounds.size.height) - textView.contentInset.bottom - textView.contentInset.top)
//        if overFlow > 0 {
//            var offset = textView.contentOffset
//            offset.y += overFlow+7
//            UIView.animateWithDuration(0.2, animations: { 
//                textView.setContentOffset(offset, animated: true)
//            })
//        }
        
        
        
        
    }

    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        
        return true
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        
        return false
    }
    
    override  func shouldShowCart() -> Bool{
        
        return true
    }
    
    override func shouldShowLeftMenu() -> Bool{
        
        return false
    }
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    override func shouldShowLeftMenuWithLogo() -> Bool{
        
        return false
    }
    override func headerTitleText() -> String{
        return "Profile"
    }
    
    override func profileDropdown() -> Bool{
        return true
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }
    

}
