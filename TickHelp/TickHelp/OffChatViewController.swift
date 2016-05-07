//
//  OffChatViewController.swift
//  TickHelp
//
//  Created by Hongda Xiao on 5/6/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import MultipeerConnectivity
import UIKit

class OffChatViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var messagesArray: [Dictionary<String, String>] = []
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var peerName: String!
    
    @IBOutlet weak var txtChat: UITextField!
    @IBOutlet weak var tblChat: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tblChat.delegate = self
        tblChat.dataSource = self
        
        tblChat.estimatedRowHeight = 60.0
        tblChat.rowHeight = UITableViewAutomaticDimension
        
        txtChat.delegate = self
        
        tblChat.estimatedRowHeight = 60.0
        tblChat.rowHeight = UITableViewAutomaticDimension
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OffChatViewController.handleMPCChatReceivedDataWithNotification(_:)), name: "receivedMPCChatDataNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OffChatViewController.handleMPCChatReceivedDisconnectionWithNotification(_:)), name: "receivedMPCDisconnectionNotification", object: nil)
        
        print("*****   View successful loaded ...")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: IBAction method implementation
    
    @IBAction func endChat(sender: AnyObject) {
        
        let messageDictionary: [String: String] = [kCommunicationsMessageTerm: kCommunicationsEndConnectionTerm]
        if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: appDelegate.mpcManager.session.connectedPeers[0] ){
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.appDelegate.mpcManager.session.disconnect()
            })
        }
        
    }
    
    
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
        /*
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
        }*/
     //   if let message = currentMessage["message"] {
//cell.messageLabel?.text = message
      //  }
        
        if let sender = currentMessage["sender"] {
            var senderLabelText: String
            var senderColor: UIColor
            
            if sender == "self"{
                senderLabelText = "I"
                senderColor = UIColor.lightGrayColor()
            }
            else{
                senderLabelText = peerName
                senderColor = UIColor.orangeColor()
            }

            cell.nameLabel?.text = senderLabelText
            cell.nameLabel?.textColor = senderColor
        }
        
        if let message = currentMessage["message"] {
            cell.messageLabel?.text = message
        }
        return cell
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let messageDictionary: [String: String] = [kCommunicationsMessageTerm: textField.text!]
        
        if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: appDelegate.mpcManager.session.connectedPeers[0] ){
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
    }
    
    func handleMPCChatReceivedDataWithNotification(notification: NSNotification) {
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
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
                
                //Reload the tableview data and scroll to the bottom using the main thread
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.updateTableview()
                })
            }else{
                let alert = UIAlertController(title: "", message: "\(fromPeer.displayName) ended this chat.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let doneAction: UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
                    self.appDelegate.mpcManager.session.disconnect()
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
                    self.updateTableview()
                })
            }else{
                let alert = UIAlertController(title: "", message: "Connections was lost with \(fromPeer.displayName)", preferredStyle: UIAlertControllerStyle.Alert)
                
                let doneAction: UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
                    self.appDelegate.mpcManager.session.disconnect()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                alert.addAction(doneAction)
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
    }
}
