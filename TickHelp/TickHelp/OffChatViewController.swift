//
//  OffChatViewController.swift
//  TickHelp
//
//  Created by Hongda Xiao on 5/6/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import MultipeerConnectivity
import UIKit
import JSQMessagesViewController

class OffChatViewController: JSQMessagesViewController{
    
    var messagesArray: [Dictionary<String, String>] = []
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var peerName: String!
    
    //JSQ STUFF
    var JSQmessages = [JSQMessage]()
    var conversation: Conversation?
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    

    
    @IBOutlet weak var txtChat: UITextField!
    @IBOutlet weak var tblChat: UITableView!
    
    
    @IBAction func offlineBackPressed(sender: UIBarButtonItem) {
        
        // need to check whether the user is using the online or the offline mode
        if(constant.uid == ""){
            let next = self.storyboard!.instantiateViewControllerWithIdentifier("offlineNearbyUsers")
            self.presentViewController(next, animated: true, completion: nil)
        }
        else{
            let next = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabBarController")
            self.presentViewController(next, animated: true, completion: nil)
        }
        // scenario one user disconnects
        if(!self.appDelegate.mpcOfflineManager.session.connectedPeers.isEmpty){
            // Code below is the same as ending a chat session
            let messageDictionary: [String: String] = [kCommunicationsMessageTerm: kCommunicationsEndConnectionTerm]
            if appDelegate.mpcOfflineManager.sendData(dictionaryWithData: messageDictionary, toPeer: appDelegate.mpcOfflineManager.session.connectedPeers[0] ){
            //    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.appDelegate.mpcOfflineManager.session.disconnect()
            //    })
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        
        // This is a beta feature that mostly works but to make things more stable I have diabled it.
        collectionView?.collectionViewLayout.springinessEnabled = false
        
        //Set the SenderId  to the current User
        // For this Demo we will use Woz's ID
        
        // Anywhere that AvatarIDWoz is used you should replace with you currentUserVariable
        //    senderId = AvatarIdWoz
        senderId = constant.nickname
        
        
        
        //    senderDisplayName = conversation?.firstName ?? conversation?.preferredName ?? conversation?.lastName ?? ""
        
        
        //      *******
        //      CAREFUL WITH THE LINE BELOW FOR THE LIST OF CHANGES
        //
        senderDisplayName = conversation?.display_nickname ?? conversation?.display_username ?? conversation?.display_username ?? ""
        automaticallyScrollsToMostRecentMessage = true

        observeMessages()
        
        
        //odd stuff
        /*
        // Do any additional setup after loading the view.
        tblChat.delegate = self
        tblChat.dataSource = self
        
        tblChat.estimatedRowHeight = 60.0
        tblChat.rowHeight = UITableViewAutomaticDimension
        
        txtChat.delegate = self
        
        tblChat.estimatedRowHeight = 60.0
        tblChat.rowHeight = UITableViewAutomaticDimension
 */
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OffChatViewController.handleMPCChatReceivedDataWithNotification(_:)), name: "receivedMPCChatDataNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OffChatViewController.handleMPCChatReceivedDisconnectionWithNotification(_:)), name: "receivedMPCDisconnectionNotification", object: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: IBAction method implementation
    
    @IBAction func endChat(sender: AnyObject) {
        
        let messageDictionary: [String: String] = [kCommunicationsMessageTerm: kCommunicationsEndConnectionTerm]
        if appDelegate.mpcOfflineManager.sendData(dictionaryWithData: messageDictionary, toPeer: appDelegate.mpcOfflineManager.session.connectedPeers[0] ){
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.appDelegate.mpcOfflineManager.session.disconnect()
            })
        }
        
    }
    
    
    /*
    // MARK: UITableView related method implementation
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  //      let cell = tableView.dequeueReusableCellWithIdentifier("idCell") as! ChatTableViewCell
  //      let cell = tableView.dequeueReusableCellWithIdentifier("idCell") as! UITableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("idOfflineCell") as! ChatViewCell
        
        let currentMessage = messagesArray[indexPath.row] as Dictionary<String, String>
        
        if let sender = currentMessage[kCommunicationsSenderTerm] {
            var senderLabelText: String
            var senderColor: UIColor
            
            if sender == kCommunicationsSelfTerm{
                senderLabelText = "I said:"
                senderColor = UIColor.purpleColor()
            }else{
                senderLabelText = sender + " said:"
                senderColor = UIColor.orangeColor()
            }
            
            cell.nameLabel?.text = senderLabelText
            cell.nameLabel?.textColor = senderColor
        }
        
        if let message = currentMessage[kCommunicationsMessageTerm]{
            cell.messageLabel?.text = message
        }
        return cell
    }*/
    
    private func observeMessages() {
        // 1
        // 2
        var i = 0
        while i < messagesArray.count{
             let currentMessage = messagesArray[i] as Dictionary<String, String>
            // 3
            if let sender = currentMessage[kCommunicationsSenderTerm] {
                let message = currentMessage[kCommunicationsMessageTerm]
                if sender == kCommunicationsSelfTerm{
                   self.JSQmessages.append(JSQMessage(senderId: constant.nickname, displayName: constant.nickname, text: message))
                }
                else{
                     self.addMessage(sender, text: message!)
                }

            }
            
            // 5
            self.finishReceivingMessage()
            i += 1
        }
    }
    func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: constant.other_nickname, text: text)
        self.JSQmessages.append(message)
    }
    
    
    
     override func didPressSendButton(button: UIButton?, withMessageText text: String?, senderId: String?, senderDisplayName: String?, date: NSDate?) {
     
     // This is where you would impliment your method for saving the message to your backend.
     //
     // For this Demo I will just add it to the messages list localy
     //
     
     //    self.messages.append(JSQMessage(senderId: AvatarIdWoz, displayName: DisplayNameWoz, text: text))
        let messageDictionary: [String: String] = [kCommunicationsMessageTerm: text!]
        
        if appDelegate.mpcOfflineManager.sendData(dictionaryWithData: messageDictionary, toPeer: appDelegate.mpcOfflineManager.session.connectedPeers[0] ){
            let dictionary: [String: String] = [kCommunicationsSenderTerm: kCommunicationsSelfTerm, kCommunicationsMessageTerm: text!]
            messagesArray.append(dictionary)
            self.JSQmessages.append(JSQMessage(senderId: constant.nickname, displayName: constant.nickname, text: text))
        }else{
            print("Could not send data")
        }
     
     self.finishSendingMessageAnimated(true)
     self.collectionView?.reloadData()
     }
    
    /*func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let messageDictionary: [String: String] = [kCommunicationsMessageTerm: textField.text!]
        
        if appDelegate.mpcOfflineManager.sendData(dictionaryWithData: messageDictionary, toPeer: appDelegate.mpcOfflineManager.session.connectedPeers[0] ){
            let dictionary: [String: String] = [kCommunicationsSenderTerm: kCommunicationsSelfTerm, kCommunicationsMessageTerm: textField.text!]
            messagesArray.append(dictionary)
            self.updateTableview()
        }else{
            print("Could not send data")
        }
        
        textField.text = ""
        return true
    }
    
    func updateTableview(){
        self.tblChat.reloadData()
        
        if self.tblChat.contentSize.height > self.tblChat.frame.size.height {
            tblChat.scrollToRowAtIndexPath(NSIndexPath(forRow: messagesArray.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
    }*/
    
    func handleMPCChatReceivedDataWithNotification(notification: NSNotification) {
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        print("Receive Data With Notification ** This method enterded.....   ")
        
        //Extract the data and the source peer from the received dictionary
        let data = receivedDataDictionary[kCommunicationsDataTerm] as? NSData
        let fromPeer = receivedDataDictionary[kCommunicationsFromPeerTerm] as! MCPeerID
        
        //Convert the data (NSData) into a Dictionary object
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! Dictionary<String,String>
        
        //Check if there's an entry with the kCommunicationsMessageTerm key
        if let message = dataDictionary[kCommunicationsMessageTerm]{
            
            if message != kCommunicationsEndConnectionTerm  {
                //Create a new dictioary and ser the sender and the received message to it
                let messageDictionary: [String: String] = [kCommunicationsSenderTerm: fromPeer.displayName, kCommunicationsMessageTerm: message]
                
                messagesArray.append(messageDictionary)
                dispatch_async(dispatch_get_main_queue()){
                    print("able to add message to messageArray")
                    //self.addMessage(fromPeer.displayName, text: message)
                    self.JSQmessages.append(JSQMessage(senderId: fromPeer.displayName, displayName: fromPeer.displayName, text: message))
                    print("able to add message to JSQMessage")
                    
                
                
                    //Reload the tableview data and scroll to the bottom using the main thread
                    self.collectionView?.reloadData()
                }
            }else{
                let alert = UIAlertController(title: "", message: "\(fromPeer.displayName) ended this chat.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let doneAction: UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
                    self.appDelegate.mpcOfflineManager.session.disconnect()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                alert.addAction(doneAction)
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                })
            }
        }
    }
    
    func handleMPCChatReceivedDisconnectionWithNotification(notification: NSNotification) {
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
        //Extract the data and the source peer from the received dictionary
        let data = receivedDataDictionary[kCommunicationsDataTerm ] as? NSData
        let fromPeer = receivedDataDictionary[kCommunicationsFromPeerTerm] as! MCPeerID
        
        //Convert the data (NSData) into a Dictionary object
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! Dictionary<String,String>
        
        //Check if there's an entry with the kCommunicationsMessageTerm key
        if let message = dataDictionary[kCommunicationsMessageTerm]{
            
            if message != kCommunicationsLostConnectionTerm  {
                //Create a new dictioary and ser the sender and the received message to it
                let messageDictionary: [String: String] = [kCommunicationsSenderTerm: fromPeer.displayName, kCommunicationsMessageTerm: message]
                
                messagesArray.append(messageDictionary)
                
                //Reload the tableview data and scroll to the bottom using the main thread
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.collectionView?.reloadData()
                })
            }else{
                let alert = UIAlertController(title: "", message: "Connections was lost with \(fromPeer.displayName)", preferredStyle: UIAlertControllerStyle.Alert)
                
                let doneAction: UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
                    self.appDelegate.mpcOfflineManager.session.disconnect()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                alert.addAction(doneAction)
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    //JSQ methods
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return JSQmessages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView?, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData? {
        return JSQmessages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView?, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource? {
        //    return messages[indexPath.item].senderId == AvatarIdWoz ? outgoingBubble : incomingBubble
        return JSQmessages[indexPath.item].senderId == constant.nickname ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource? {
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = JSQmessages[indexPath.item]
        switch message.senderId {
            
        case constant.nickname:
            //    case AvatarIdWoz:
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
        //    return messages[indexPath.item].senderId == AvatarIdWoz ? 0 : kJSQMessagesCollectionViewCellLabelHeightDefault
        return JSQmessages[indexPath.item].senderId == constant.nickname ? 0 : kJSQMessagesCollectionViewCellLabelHeightDefault
    }
}
