//
//  LFChatListViewController.swift
//  Lefoodie
//
//  Created by apple on 22/03/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import Firebase

class LFChatListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    lazy var userRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Apps").child(CXAppConfig.sharedInstance.getAppMallID()).child("Users")
    

    lazy var messageRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Apps").child(CXAppConfig.sharedInstance.getAppMallID()).child("Messages")
    lazy var userChatListRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Apps").child(CXAppConfig.sharedInstance.getAppMallID()).child("Users")
    
    private var newMessageRefHandle: FIRDatabaseHandle?
    private var updatedMessageRefHandle: FIRDatabaseHandle?
    private var channelRefHandle: FIRDatabaseHandle?
    private var channels = NSMutableArray()
    
    var userDetailsDic : NSDictionary?
    var channelRef: FIRDatabaseReference?
    var userID : String = String()
    var selectedList = NSMutableArray()
    
    @IBOutlet weak var chatNameLbl: UILabel!
    @IBOutlet weak var chatListTbl: UITableView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var noChatsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createChatTableView()
        self.getAllChatList()
    }
    
    func createChatTableView(){
        //let screen = UIScreen.main.bounds
        self.chatListTbl.tableFooterView = UIView()
        self.noChatsLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        let nib = UINib(nibName: "LFChatTableViewCell", bundle: nil)
        self.chatListTbl.register(nib, forCellReuseIdentifier: "LFChatTableViewCell")
        //self.setNavigationProperties()
        self.editBtn.setTitle("Edit", for: .normal)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigationProperties(){
        self.navigationController?.isNavigationBarHidden = true
        let backItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action:  #selector(LFChatListViewController.backAction))
        backItem.title = "Back"
        self.navigationController?.navigationItem.leftBarButtonItem = backItem
        //self.navigationController?.navigationBar.setColors(background: UIColor.appTheamColor(), text: UIColor.white)
        //self.navigationController?.navigationBar.setNavBarImage(setNavigationItem: self.navigationItem)
        self.navigationController?.navigationBar.backItem?.title = "Anything Else"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func getAllChatList(){
        
        // We can use the observe method to listen for new
        // channels being written to the Firebase DB
        //self.userID = "66"
        
        let channelRef = userChatListRef.child(userID).child("msg_grp_ids")
        
        /*  channelRefHandle = channelRef.observe(.value, with: { (snapshot) -> Void in
         let channelData = snapshot.value as! Dictionary<String, AnyObject>
         if let name = channelData["name"] as! String!, name.characters.count > 0 , let imgUrl = channelData["image_url"] as! String! {
         
         if channelData["msg_id"]  is String {
         self.channels.append(Channel(id: String(channelData["msg_id"]  is String), name: name, imageUrl: imgUrl))
         }else{
         let msgID = channelData["msg_id"] as! Int!
         self.channels.append(Channel(id: String(describing: msgID), name: name, imageUrl: imgUrl))
         }
         print(self.channels)
         self.chatListTbl.reloadData()
         
         } else {
         print("Error! Could not decode channel data")
         }
         })
         */
        
        
        channelRef.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            for channelSnap in snapshot.children {
                let channelData = (channelSnap as! FIRDataSnapshot).value as! Dictionary<String, AnyObject>
                if let name = channelData["name"] as! String!, name.characters.count > 0  {
                    if channelData["msg_id"]  is String {
                        self.channels.add(channelData)
                        // self.channels.append(Channel(id: String(channelData["msg_id"]  is String), name: name, imageUrl: ""))
                    }else{
                        //let msgID = channelData["msg_id"] as! Int!
                        //self.channels.append(Channel(id: String(describing: msgID), name: name, imageUrl: ""))
                        self.channels.add(channelData)
                    }
                } else {
                    CXLog.print("Error! Could not decode channel data")
                }
                //channelData["image_url"] as! String!
            }
            CXLog.print( self.channels)
            self.chatListTbl.reloadData()
            
        })
        
    }
    
    deinit {
        if let refHandle = newMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
        if let refHandle = updatedMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
    }
    
    @IBAction func editBtnAction(_ sender: UIButton) {
        // sender.isSelected = !sender.isSelected
        if sender.titleLabel?.text == "Edit"{
            chatListTbl.setEditing(true, animated: true)
            isEditing = true
            self.editBtn.setTitle("Delete", for: .normal)
        }else{
            self.editBtn.setTitle("Edit", for: .normal)
            isEditing = false
            chatListTbl.setEditing(false, animated: true)
            delteTheChatListFromFirebase()
        }
    }
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if channels.count == 0{
            self.editBtn.isHidden = true
            self.noChatsLbl.isHidden = false
        }else{
            self.editBtn.isHidden = false
            self.noChatsLbl.isHidden = true
        }
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LFChatTableViewCell", for: indexPath)as? LFChatTableViewCell
        let channelData =  channels.object(at: indexPath.row) as? Dictionary<String, Any>
        
        cell?.chatNameLbl.text = channelData?["name"] as? String
        tableView.separatorStyle = .singleLine
        
        if  let fromUserPic = channelData?["image_url"] as? String , !fromUserPic.isEmpty{
            let img_Url = NSURL(string: fromUserPic )
            cell?.chatImg.setImageWith(img_Url as URL!, usingActivityIndicatorStyle: .white)
        }
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing{
            CXLog.print("user selected \(channels.object(at: indexPath.row))")
            selectedList.add(channels.object(at: indexPath.row))
        }else{
            let channelData =  channels.object(at: indexPath.row) as? Dictionary<String, Any>
            var msgID = ""
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IMChatViewController")as? IMChatViewController
            
            if channelData?["msg_id"]  is String {
                msgID = channelData?["msg_id"]  as! String
                storyboard?.chatID = msgID
                
            }else{
                if let result_number =  channelData?["msg_id"] as? NSNumber
                {
                    storyboard?.chatID = "\(result_number)"
                }
            }
            
            if let chatEail = channelData?["email"]  as? String {
                storyboard?.selectedChatEmail = chatEail
            }
            
            /*
             self.title = chatName
             self.senderId = self.userDetailsDic?["FromUserId"] as! String!
             sel//userIDf.senderDisplayName = self.userDetailsDic?["FromUserName"] as! String!
             /*Optional(["msg_id": 1491817536468, "name": Sushi Omakase, "email": sushiomakase_sog@ongo.com, "image_url": , "uid": 67])
             
             chatData.setValue((String(describing: restaurantDict.value(forKey: "id") as? String)), forKey: "ToUserId")
             chatData.setValue(restaurantDict.value(forKey: "name"), forKey: "ToUserName")
             chatData.setValue(restaurantDict.value(forKey: "email"), forKey: "ToUserEmail")*/
             */
            
            storyboard?.userDetailsDic = self.userDetailsDic
            storyboard?.isFromList = true
            storyboard?.chatName = (channelData?["name"] as? String)!
            self.navigationController?.pushViewController(storyboard!, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        CXLog.print("user de-selected \(channels.object(at: indexPath.row))")
        selectedList.remove(channels.object(at: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete{
            channels.remove(at: indexPath.row)
            self.afterRowDeleted()
            self.chatListTbl.deleteRows(at: [indexPath], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        isEditing = true
        return UITableViewCellEditingStyle(rawValue: 3)!
    }
    
    func afterRowDeleted(){
        CXLog.print("Row Deleted Code Goes Here")
    }
    
    func delteTheChatListFromFirebase(){
        
        let currentUserMsgId = userChatListRef.child(self.userID).child("msg_grp_ids")
        
        //Delete the message id in touser and fromuser
        
        for obj in selectedList {
            /*  {
             email = "applebees_sog@ongostore.com";
             "image_url" = "https://scontent.xx.fbcdn.net/v/t1.0-1/p50x50/17021588_10155057759184334_8317501606812198219_n.jpg?oh=fb54706c36876897a5cb291a2cfa60e6&oe=5969106A";
             "msg_id" = 1492754409810;
             name = "Applebee's Grill & Bar";
             uid = 49;
             userID = 45;
             } */
            
            let dict = obj as! NSDictionary
            if let userId = dict.value(forKey: "userID") {
                currentUserMsgId.child(userId as! String).removeValue { (error , ref) in
                }
                
            }
            /*      if let msgId = dict.value(forKey: "uid") {
             let otherUserMsgId = userChatListRef.child(msgId as! String).child("msg_grp_ids")
             otherUserMsgId.child(self.userID!).removeValue { (error , ref) in
             
             }
             }  */
            
        }
        self.channels = NSMutableArray()
        self.getAllChatList()
    }
}
