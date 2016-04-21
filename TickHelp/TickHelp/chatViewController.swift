//
//  chatViewController.swift
//  TickHelp
//
//  Created by Ariel on 4/12/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class chatViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var textChat: UITextField!
    
    @IBOutlet weak var chatTable: UITableView!
    
    var messagesArray: [Dictionary<String, String>] = []
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        chatTable.delegate = self
        chatTable.dataSource = self
    
        chatTable.estimatedRowHeight = 80.0
        chatTable.rowHeight = UITableViewAutomaticDimension
        
        chatTable.rowHeight = 70.0
        
        textChat.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(chatViewController.handleMPCChatReceivedDataWithNotification(_:)), name: "receivedMPCChatDataNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(chatViewController.handleMPCChatReceivedDisconnectionWithNotification(_:)), name: "receivedMPCDisconnectionNotification", object: nil)
        
        chatTable.separatorStyle = UITableViewCellSeparatorStyle.None

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopChat(sender: AnyObject) {
        
        let messageDictionary: [String: String] = ["message": "_end_chat_"]
        if appDelegate.mpcManager!.sendData(dictionaryWithData: messageDictionary, toPeer: appDelegate.mpcManager!.session.connectedPeers[0] ){
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.appDelegate.mpcManager!.session.disconnect()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell")! as! chatTableViewCell
        
        let currentMessage = messagesArray[indexPath.row] as Dictionary<String, String>
        
        if let sender = currentMessage["sender"] {
            var senderLabelText: String
            var senderColor: UIColor
            
            if sender == "self"{
                senderLabelText = "I said:"
                senderColor = UIColor.purpleColor()
            }
            else{
                senderLabelText = sender + " said:"
                senderColor = UIColor.orangeColor()
            }
            
            cell.name?.text = senderLabelText
            cell.name?.textColor = senderColor
        }
        
        if let message = currentMessage["message"] {
            cell.messenge?.text = message
        }
        
        return cell
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        let messageDictionary: [String: String] = ["message": textField.text!]
        
        if appDelegate.mpcManager!.sendData(dictionaryWithData: messageDictionary, toPeer: appDelegate.mpcManager!.session.connectedPeers[0] ){
            let dictionary: [String: String] = ["sender": "self", "message": textField.text!]
            messagesArray.append(dictionary)
            
            self.updateTableview()
        }else{
            print("Could not send data")
        }
        
        textField.text = ""
        return true
    
    }
    
    func updateTableview(){
        self.chatTable.reloadData()
        
        if self.chatTable.contentSize.height > self.chatTable.frame.size.height {
            chatTable.scrollToRowAtIndexPath(NSIndexPath(forRow: messagesArray.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
    }
    
    func handleMPCChatReceivedDataWithNotification(notification: NSNotification) {

        
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
        // "Extract" the data and the source peer from the received dictionary.
        let data = receivedDataDictionary["data"] as? NSData
        let fromPeer = receivedDataDictionary["fromPeer"] as! MCPeerID
        
        // Convert the data (NSData) into a Dictionary object.
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! Dictionary<String, String>
        
        // Check if there's an entry with the "message" key.
        if let message = dataDictionary["message"] {
            // Make sure that the message is other than "_end_chat_".
            if message != "_end_chat_"{
                // Create a new dictionary and set the sender and the received message to it.
                let messageDictionary: [String: String] = ["sender": fromPeer.displayName, "message": message]
                
                // Add this dictionary to the messagesArray array.
                messagesArray.append(messageDictionary)
                
                // Reload the tableview data and scroll to the bottom using the main thread.
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.updateTableview()
                })
            }
            else{
                let alert = UIAlertController(title: "", message: "\(fromPeer.displayName) ended this chat.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let doneAction: UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
                    self.appDelegate.mpcManager!.session.disconnect()
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
        
        //Extract the data and the source peer from the received dictionary
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
        //Extract the data and the source peer from the received dictionary
        let data = receivedDataDictionary["data"] as? NSData
        let fromPeer = receivedDataDictionary["fromPeer"] as! MCPeerID
        
        //Convert the data (NSData) into a Dictionary object
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! Dictionary<String,String>
        
        //Check if there's an entry with the kCommunicationsMessageTerm key
        if let message = dataDictionary["message"]{
            
            if message != "_lost_connection_"  {
                //Create a new dictioary and ser the sender and the received message to it
                let messageDictionary: [String: String] = ["sender": fromPeer.displayName, "message": message]
                
                messagesArray.append(messageDictionary)
                
                //Reload the tableview data and scroll to the bottom using the main thread
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.updateTableview()
                })
            }else{
                let alert = UIAlertController(title: "", message: "Connections was lost with \(fromPeer.displayName)", preferredStyle: UIAlertControllerStyle.Alert)
                
                let doneAction: UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
                    self.appDelegate.mpcManager!.session.disconnect()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

