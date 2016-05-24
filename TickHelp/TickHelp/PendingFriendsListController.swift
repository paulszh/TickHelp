//
//  PendingFriendsListController.swift
//  TickHelp
//
//  Created by Hongda Xiao on 5/24/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit
import Firebase

class PendingFriendListController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var friendTable: UITableView!
    
    var friendName : [String!] = []
    var friendId : [String!] = []
    
    var conversations = [Conversation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        friendTable.delegate = self
        friendTable.dataSource = self
        
        // Register cell classes
        friendTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "idCellPeer")
        
        //Get friend list
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Get friend list
        
        
        conversations = []
        
        let uid = Firebase(url: constant.userURL).authData.uid
        let ref = Firebase(url: constant.userURL + "/users/" + uid + "/friends")
        
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            
            
            let uid = snapshot.value.objectForKey("uid") as! String!
            let nickname = snapshot.value.objectForKey("nickname") as! String!
            let username = snapshot.value.objectForKey("username") as! String!
            
            let newCon = Conversation(display_nickname: nickname, display_username: username, display_uid: uid, latestMessage: username, isRead: false)
            self.conversations.append(newCon)
            
            print("count: \(uid)")
            print("count1: \(self.conversations.count)")
            
            self.friendTable.reloadData()
        })
        
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell")! as UITableViewCell
        
        if(conversations.count <= indexPath.row) {
            return UITableViewCell()
        }
        
        cell.textLabel!.text = conversations[indexPath.row].display_nickname
        
        cell.textLabel!.font = UIFont(name:"Avenir", size:20)
        
        cell.imageView?.image = UIImage(named: "face")
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // retrieve the user that we are currently chatting with so we can
        // update the firebase database accordingly
        // This is to know whom we are communicating with. might need to be refactored a little.
        
        constant.other_uid = conversations[indexPath.row].display_uid!
        
        print(constant.other_uid)
        // need to get the nickname of the user that we are communicating with
        
        let otherUserRef = Firebase(url: constant.userURL).childByAppendingPath("users").childByAppendingPath(constant.other_uid)
        
        otherUserRef.observeEventType(.Value, withBlock: { snapshot in
            // print(snapshot.value)
            
            constant.other_nickname = (snapshot.value.objectForKey("nickname") as? String)!
            constant.other_username = (snapshot.value.objectForKey("username") as? String)!
            
            //   print("The nickname is: \(constant.usernameFromOtherUser)")
            }, withCancelBlock: { error in
                print(error.description)
        })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let conversationController = segue.destinationViewController as? JSQChatViewController, row = sender as? Int {
            conversationController.conversation = self.conversations[row]
        }
    }
}