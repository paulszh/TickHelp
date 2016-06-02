//
//  JSQChatViewController.swift
//  TickHelp
//
//  Created by Hongda Xiao on 5/15/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class JSQChatViewController: JSQMessagesViewController {
    var messageRef: Firebase!
    var oppositeMessageRef: Firebase!
    
    var messages = [JSQMessage]()
    
    var conversation: Conversation?
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    
    let conversationRef = Firebase(url: constant.userURL).childByAppendingPath("users").childByAppendingPath(constant.uid).childByAppendingPath("MessageList");
    let oppositeConversationRef = Firebase(url: constant.userURL).childByAppendingPath("users").childByAppendingPath(constant.other_uid).childByAppendingPath("MessageList");
    
    
    var isFriend = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputToolbar?.contentView?.leftBarButtonItem = nil
        
    //    print("The uid of the current messaging user is: \(constant.uid)")
    //    print("The messaging user's username is: \(constant.nickname)")
    //    print("The uid of the other user is: \(constant.other_user_on_chat)")
        /*
        self.conversationRef.childByAppendingPath("MessageList").childByAppendingPath("other_user_uid").setValue(constant.other_user_on_chat)
        // works both ways... the other user will update the database as well
        let currRef = Firebase(url: constant.userURL).childByAppendingPath("users").childByAppendingPath(constant.other_user_on_chat).childByAppendingPath("MessageList").childByAppendingPath("other_user_uid").setValue(constant.uid); */
        messageRef = conversationRef.childByAppendingPath("messages")
        oppositeMessageRef = oppositeConversationRef.childByAppendingPath("messages")
        

        
        // This is how you remove Avatars from the messagesView
        collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        
        // This is a beta feature that mostly works but to make things more stable I have diabled it.
        collectionView?.collectionViewLayout.springinessEnabled = false
        
        //Set the SenderId  to the current User
        // For this Demo we will use Woz's ID

        // Anywhere that AvatarIDWoz is used you should replace with you currentUserVariable
    //    senderId = AvatarIdWoz
        senderId = constant.nickname
        
        let ref = Firebase(url: constant.userURL + "/users/" + constant.uid + "/friends")
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            let tempUid = snapshot.value.objectForKey("uid") as! String
            print("tempUid: \(tempUid)")
            if(tempUid == constant.other_uid){
                self.isFriend = true
                print("they are friends")
            }
        })
                
                 

        
        
        
    //    senderDisplayName = conversation?.firstName ?? conversation?.preferredName ?? conversation?.lastName ?? ""
        
        
        //      *******
        //      CAREFUL WITH THE LINE BELOW FOR THE LIST OF CHANGES
        //
        senderDisplayName = conversation?.display_nickname ?? conversation?.display_username ?? conversation?.display_username ?? ""
        automaticallyScrollsToMostRecentMessage = true
        
  //      if (conversation?.smsNumber) != nil {
  //          self.messages = makeConversation()
  //          self.collectionView?.reloadData()
  //          self.collectionView?.layoutIfNeeded()
  //      }
        observeMessages()
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    //    observeMessages()
    }
    
    private func observeMessages() {
        // 1
        let messagesQuery = messageRef.queryLimitedToLast(25)
        // 2
        messagesQuery.observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) in
            // 3
            let id = snapshot.value["senderId"] as! String
            let text = snapshot.value["text"] as! String
            
            // 4 Need to make sure not to display messages sent by self
            let sender = snapshot.value["senderId"] as! String
            let receiver = snapshot.value["opposite_senderID"] as! String
           // print("senderId: \(sender)" )
            if(sender == constant.other_uid){
                self.addMessage(id, text: text)
            }
            else if (receiver == constant.other_uid) {
                self.messages.append(JSQMessage(senderId: constant.nickname, displayName: constant.nickname, text: text))
                
            }
            // 5
            self.finishReceivingMessage()
        }
    }
    func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: constant.other_nickname, text: text)
        messages.append(message)
    }
    /*
    override func didPressSendButton(button: UIButton?, withMessageText text: String?, senderId: String?, senderDisplayName: String?, date: NSDate?) {
        
        // This is where you would impliment your method for saving the message to your backend.
        //
        // For this Demo I will just add it to the messages list localy
        //
        
    //    self.messages.append(JSQMessage(senderId: AvatarIdWoz, displayName: DisplayNameWoz, text: text))
        self.messages.append(JSQMessage(senderId: constant.nickname, displayName: constant.nickname, text: text))
        self.finishSendingMessageAnimated(true)
        self.collectionView?.reloadData()
    }*/
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let itemRef = messageRef.childByAutoId() // 1
        let messageItem = [ // 2
            "text": text,
            "senderId": constant.uid,
            "opposite_senderID" : constant.other_uid,
        ]
        itemRef.setValue(messageItem) // 3
        
        // also set the database of the opposite user
        
        let oppositeItemRef = oppositeMessageRef.childByAutoId()
        let oppositeMessageItem = [ // 2
            "text": text,
            "senderId": constant.uid,
            "opposite_senderID" : constant.other_uid,
        ]
        oppositeItemRef.setValue(oppositeMessageItem)
        
        // 4
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        // 5
        finishSendingMessage()
        
        self.finishSendingMessageAnimated(true)
        self.collectionView?.reloadData()
    }
    @IBAction func backBtnPressed(sender: UIBarButtonItem) {
        
        let next = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabBarController")
        self.presentViewController(next, animated: true, completion: nil)

    }
    
    @IBAction func AddFriendBtn(sender: AnyObject) {
        
        if(isFriend){
            SweetAlert().showAlert("Oops!", subTitle: "\(constant.other_nickname) is already your friend", style: AlertStyle.Warning, buttonTitle:"OK", buttonColor:UIColor.grayColor() )
        }
            
        else{
        let alertController = UIAlertController(title: nil, message: "What would you like to do?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // Nothing to do here
        }
        alertController.addAction(cancelAction)
        
            let OKAction = UIAlertAction(title: "Add Friend", style: .Default) { (action) in
            // TO-DO
            // Add code to update friend status in firebase
            //User info
            let uid = Firebase(url: constant.userURL).authData.uid
            let ref = Firebase(url: constant.userURL + "/users/" + uid)
            let listRef = ref.childByAppendingPath("friends")
            
            
            //Add Friend
            
            let friend = ["uid": constant.other_uid,
                          "nickname" : constant.other_nickname,
                          "username" : constant.other_username,
                          "accepted" : false,
                          "needToAccept" : false]
            
            print("username: \(constant.other_username)" )
            print("nickname: \(constant.other_nickname)" )
            
            let friendRef = listRef.childByAutoId()
            
            friendRef.setValue(friend, withCompletionBlock: {
                (error:NSError?, ref:Firebase!) in
                if (error != nil) {
                    print("Data could not be saved.")
                } else {
                    print("Data saved successfully!")
                }
            })
            
            
            //Opposite info
            let oppositeUid = constant.other_uid
            let oppositeRef = Firebase(url: constant.userURL + "/users/" + oppositeUid)
            let oppositeListRef = oppositeRef.childByAppendingPath("friends")
            
            
            let oppositeFriend = ["uid": constant.uid,
                                  "nickname" : constant.nickname,
                                  "username" : constant.username,
                                  "accepted" : false,
                                  "needToAccept" : true]
            
            print("username: \(constant.other_username)" )
            print("nickname: \(constant.other_nickname)" )
            
            let oppositeFriendRef = oppositeListRef.childByAutoId()
            
            oppositeFriendRef.setValue(oppositeFriend, withCompletionBlock: {
                (error:NSError?, ref:Firebase!) in
                if (error != nil) {
                    print("Data could not be saved.")
                } else {
                    print("Data saved successfully!")
                }
            })
            
        }
        alertController.addAction(OKAction)
        
        let rateAction = UIAlertAction(title: "ThumbsUp!", style: .Default) { (action) in
            print(action)
        }
        alertController.addAction(rateAction)
        
        self.presentViewController(alertController, animated: true) {
            // TODO
            // Add code here to delete friend request status in firebase
        }
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView?, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData? {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView?, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource? {
        return messages[indexPath.item].senderId == constant.nickname ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource? {
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        switch message.senderId {
            
        case constant.nickname:
            return nil
        default:
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
            
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView?, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout?, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return messages[indexPath.item].senderId == constant.nickname ? 0 : kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
}
