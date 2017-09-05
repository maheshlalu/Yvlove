//
//  IMChatViewController.swift
//  IndianMatriMony
//
//  Created by apple on 01/08/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class IMChatViewController: JSQMessagesViewController {
    
    lazy var messageRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Apps").child(CXAppConfig.sharedInstance.getAppMallID()).child("Messages")
    lazy var userRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Apps").child(CXAppConfig.sharedInstance.getAppMallID()).child("Users")
    @IBOutlet weak var navigationLbl: UILabel!
    
    private var newMessageRefHandle: FIRDatabaseHandle?
    private var updatedMessageRefHandle: FIRDatabaseHandle?
    private var messages: [JSQMessage] = []
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    
    var userDetailsDic : NSDictionary?
    var isFromList = false
    var chatID = ""
    
    var chatName = String()
    var selectedChatEmail = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationLbl.text = "\(dataDic["FromUserName"] as? String!)"
        // getMyProfile()
        //self.retriveTheMessages()
        if isFromList{
            self.retriveTheMessages(chatID: chatID)
        }else{
            self.retriveTheChatIDBetweenFromAndToUser()
        }
        self.setup()
        //self.setNavigationProperties()
        self.collectionView.delegate = self

        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setNavigationProperties(){
        self.navigationController?.isNavigationBarHidden = false
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "leftArrow"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setLeftBarButton(item1, animated: true)
    }
    
    func goBack(){
        if isFromList {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true) {
                
            }
        }
    }

    func retriveTheMessages(chatID:String){
        self.messageRef =  messageRef.child(chatID)
        let messageQuery = messageRef.queryOrderedByValue()
        // We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            let messageData = snapshot.value as! Dictionary<String, String>
            if let id = messageData["senderId"] as String!, let name = messageData["name"] as String!, let text = messageData["message"] as String!, text.characters.count > 0 {
                self.addMessage(withId: id, name: name, text: text)
                self.finishReceivingMessage()
            } else {
                CXLog.print("Error! Could not decode message data")
            }
        })
    }
    
    
    // MARK: UI and User Interaction
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: CXAppConfig.sharedInstance.getAppTheamColor())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    
    func setup() {
        print(chatName)
        self.title = chatName
        self.senderId = self.userDetailsDic?["FromUserId"] as! String!
        self.senderDisplayName = self.userDetailsDic?["FromUserName"] as! String!
        self.navigationController?.navigationItem.title =  self.senderDisplayName
        
    }
    
    func retriveTheChatIDBetweenFromAndToUser(){
        
        
        /*
         
         chatData.setValue(myProfile.userEmail, forKey: "FromUserEmail")
         chatData.setValue(myProfile.userName, forKey: "FromUserName")
         chatData.setValue(myProfile.userId, forKey: "FromUserId")
         
         
         if let myInteger = Int((restaurantDict.value(forKey: "id") as? String)!) {
         var toID = NSNumber(value:myInteger)
         
         var int : Int = Int(toID)
         int += 1
         toID = NSNumber(value: int)
         
         chatData.setValue(String(describing: toID), forKey: "ToUserId")
         chatData.setValue(restaurantDict.value(forKey: "name"), forKey: "ToUserName")
         chatData.setValue(restaurantDict.value(forKey: "email"), forKey: "ToUserEmail")
         
         */
        
        if let fromUserID = self.userDetailsDic?["FromUserId"] as! String!,let toName = self.userDetailsDic?["ToUserName"] as! String! ,let toUserID = self.userDetailsDic?["ToUserId"] as! String! {
            self.checkTheUserExits(currentUserID: fromUserID, toUserID: toUserID, userImage: "", userName: toName,dataDic:self.userDetailsDic!) { (fireBase) in
                self.retriveTheMessages(chatID: fireBase)
            }
        }
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    // MARK: Collection view data source (and related) methods
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        let messageStr = message.text
        if message.senderId == senderId { // 1
            cell.textView?.textColor = UIColor.white // 2
        } else {
            cell.textView?.textColor = UIColor.black // 3
        }
        cell.textView.isUserInteractionEnabled = true
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        // 1
        let itemRef = self.messageRef
        CXLog.print(itemRef)
        // 2
        let messageItem = [
            "senderId": senderId!,
            "name": senderDisplayName!,
            "message": text!,
            ]
        
        
        
        // 3
        itemRef.child(itemRef.childByAutoId().key).setValue(messageItem)
        
        // 4
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        // 5
        finishSendingMessage()
        //isTyping = false
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension IMChatViewController{
    
    
    //MARK: Message

        
        
        func checkTheUserExits(currentUserID:String,toUserID:String,userImage:String,userName:String,dataDic:NSDictionary,completion:@escaping (_ commnChtaID:String)->Void) {
            
            
            let currentUserRef: FIRDatabaseReference =  userRef.child(currentUserID).child("msg_grp_ids").child(toUserID)
            
            
            currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if value == nil{
                    //Create the new chat Id between two users
                    self.addTheNewChatIDForBothUsers(currentUserID: currentUserID, toUserId: toUserID, userImage: userImage, userName: userName,dataDic:dataDic, completionBlock: { (chatID) in
                        CXLog.print(currentUserRef)
                        completion(chatID)
                        
                    })
                }else{
                    if value?["msg_id"] is String {
                        if let messageID = value?["msg_id"] as! String!{
                            CXLog.print(messageID)
                            completion(messageID)
                        }
                    }else if value?["msg_id"] is Int{
                        if let messageID = value?["msg_id"] as! Int!{
                            completion(String(messageID))
                        }
                    }
                }
                /*
                 "image_url" = jhagsdjhgsajd;
                 "msg_id" = 198342;
                 name = Mahesh;
                 */
                // let chatReference: FIRDatabaseReference = currentUserRef
                //CXLog.print(val)
                
            })
            
        }
        
        
        func addTheNewChatIDForBothUsers(currentUserID:String,toUserId:String,userImage:String,userName:String,dataDic:NSDictionary,completionBlock:(_ chatID:String)->Void){
            // CXLog.print("\(dataDic)")
            if  let fromUserPic = dataDic.value(forKey: "FromUserPic") as! String!, let fromUserEail = dataDic.value(forKey: "FromUserEmail") as! String!{
                let currentTime = String.getCurrentMillis()
                let timeStr = "\(currentTime)"
                var toUserImage = ""
                if var userimage1 = dataDic["ToUserPic"] as! String! {
                    toUserImage = userimage1
                }
                let currentUserPost = ["uid": currentUserID,
                                       "image_url": toUserImage,
                                       "msg_id": timeStr,
                                       "name": userName,
                                       "email": dataDic.value(forKey: "ToUserEmail") as! String!,
                                       "userID": toUserId
                    
                    ] as [String : Any]
                
                
                let toUserPostDic =  ["uid": toUserId,
                                      "image_url": fromUserPic,
                                      "msg_id": timeStr,
                                      "name": dataDic["FromUserName"] as? String!,
                                      "email": fromUserEail,
                                      "userID": currentUserID
                    ] as [String : Any]
                
                //CXLog.print(toUserPostDic)
                // CXLog.print(currentUserPost)
                //msg_grp_ids
                self.userRef.child(currentUserID).child("msg_grp_ids").child(toUserId).setValue(currentUserPost)
                self.userRef.child(toUserId).child("msg_grp_ids").child(currentUserID).setValue(toUserPostDic)
                completionBlock(timeStr)
            }
        }
        
        func genarateTheChatID(messageID:String){
            
            /*  let currentUserPost = ["uid": messageID,
             "message": "0",
             "name": "0",
             "senderId": messageID,
             "timeStamp": messageID,
             
             ] as [String : Any]*/
            
            // self.messageRef.child(messageID).setValue(messageID)
            
            //messages
        }
    }
