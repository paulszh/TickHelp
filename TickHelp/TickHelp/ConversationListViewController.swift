//
//  ConversationListViewController.swift
//  TickHelp
//
//  Created by Hongda Xiao on 5/15/16.
//  Copyright © 2016 Ariel. All rights reserved.
//
class ConversationTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recentTextLabel: UILabel!
}

import UIKit
import Firebase
import GeoFire

class ConversationsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView?
    
    var conversations = [Conversation]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        conversations.removeAll()
        loadDataFromFirebase()
     
     //   data has been loaded in loadDataFromFirebase()
     //   self.conversations = getConversation()
        self.tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    self.tableView?.reloadData()
        
        // Hides empty cells
        tableView?.tableFooterView = UIView()
    }
    
    func loadDataFromFirebase(){
        let geofireRef = Firebase(url: constant.userURL)
        let geoPath = geofireRef.childByAppendingPath("locations")
        let geoFire = GeoFire(firebaseRef: geoPath)
        
        geoFire.setLocation(CLLocation(latitude: 37.7853889, longitude: -122.4056973), forKey: constant.uid) { (error) in
            if (error != nil) {
                print("An error occured: \(error)")
            } else {
                print("Saved location successfully!")
            }
        }
        
        let center = CLLocation(latitude: 37.7832889, longitude: -122.4056973)
        // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
        let circleQuery = geoFire.queryAtLocation(center, withRadius: 0.6)
        
        var queryHandle = circleQuery.observeEventType(.KeyEntered, withBlock: { (key: String!, location: CLLocation!) in
            //    print("Key '\(key)' entered the search area and is at location '\(location)'")
            let refPath = geofireRef.childByAppendingPath("users")
                .childByAppendingPath(key)
            
            // Get the data on a post that has changed
            refPath.observeEventType(.Value, withBlock: { snapshot in
                // retrieve data
                let getCurrName = snapshot.value.objectForKey("nickname") as? String
                let getCurrUsername = snapshot.value.objectForKey("username") as? String
                // Should not add current logged-in uid to the display list
                if(constant.uid != key){
                    let newCon = Conversation(display_nickname: getCurrName, display_username: getCurrUsername, display_uid: key, latestMessage: getCurrUsername, isRead: false)
                    self.conversations.append(newCon)
                }
                else{
                    // store current user's info into the global constants
                    constant.username = (snapshot.value.objectForKey("username") as? String)!
                    constant.nickname = (snapshot.value.objectForKey("nickname") as? String)!
                }
                
                self.tableView?.reloadData()
                }, withCancelBlock: { error in
                    print(error.description)
            })
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let conversation = conversations[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? ConversationTableViewCell else {
            return UITableViewCell()
        }
        
        //        cell.avatarView.setup(conversation.patientId)
      ///  cell.nameLabel.text = "Chat with The Guys"
        cell.nameLabel.text = self.conversations[indexPath.row].display_nickname
        cell.recentTextLabel.text = conversation.latestMessage
        
        // Check if the conversation is read and apply Bold/Not Bold to the text to indicate Read/Unread state
     //   !conversation.isRead ? cell.nameLabel.font = cell.nameLabel.font.bold() : (cell.nameLabel.font = cell.nameLabel.font.withTraits([]))
 
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // retrieve the user that we are currently chatting with so we can 
        // update the firebase database accordingly
        // This is to know whom we are communicating with. might need to be refactored a little.
        
        constant.other_user_on_chat = self.conversations[indexPath.row].display_uid!
        print(constant.other_user_on_chat)
        // need to get the nickname of the user that we are communicating with
        let otherUserRef = Firebase(url: constant.userURL).childByAppendingPath("users").childByAppendingPath(constant.other_user_on_chat)
        otherUserRef.observeEventType(.Value, withBlock: { snapshot in
           // print(snapshot.value)
            constant.usernameFromOtherUser = (snapshot.value.objectForKey("nickname") as? String)!
         //   print("The nickname is: \(constant.usernameFromOtherUser)")
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        performSegueWithIdentifier("ConversationSegue", sender: indexPath.row)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let conversationController = segue.destinationViewController as? JSQChatViewController, row = sender as? Int {
            let conversation = conversations[row]
            conversationController.conversation = conversation
        }
    }
    
    //MARK: Helper Methods for formating phone numbers
    func formatPhoneNumber(phoneNumber: String?) -> String {
        guard var phoneNumber = phoneNumber else {
            return ""
        }
        if phoneNumber.characters.count == 10 {
            phoneNumber.insert("(", atIndex: phoneNumber.startIndex)
            phoneNumber.insert(")", atIndex: phoneNumber.startIndex.advancedBy(4))
            phoneNumber.insert("-", atIndex: phoneNumber.startIndex.advancedBy(8))
        }
        return phoneNumber
    }
}


extension UIFont {
    
    //This is used for making unread messages bold
    
    func withTraits(traits: UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(.TraitBold)
    }
    
}