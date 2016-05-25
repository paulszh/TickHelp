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
    var needToAccepts = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        friendTable.delegate = self
        friendTable.dataSource = self
        
        // Register cell classes
        //friendTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "pendingFriendCell")
        
        //Get friend list
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Get friend list
        
        
        conversations = []
        
        let uid = Firebase(url: constant.userURL).authData.uid
        let ref = Firebase(url: constant.userURL + "/users/" + uid + "/friends")
        
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            
            //check if the friend request has been acccepted
            let accepted = snapshot.value.objectForKey("accepted") as! Bool
            if(!accepted){
                let needToAccept = snapshot.value.objectForKey("needToAccept") as! Bool
                //check if the user needs to accept the friend request
                let uid = snapshot.value.objectForKey("uid") as! String!
                let nickname = snapshot.value.objectForKey("nickname") as! String!
                let username = snapshot.value.objectForKey("username") as! String!
            
                let newCon = Conversation(display_nickname: nickname, display_username: username, display_uid: uid, latestMessage: username, isRead: false)
                self.conversations.append(newCon)
                self.needToAccepts.append(needToAccept)
                
                print("count: \(uid)")
                print("count1: \(self.conversations.count)")
            
                self.friendTable.reloadData()
            }
        })
        
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.friendTable.dequeueReusableCellWithIdentifier("pendingFriendCell", forIndexPath:indexPath) as! PendingFriendCell
        
        if(conversations.count <= indexPath.row) {
            return UITableViewCell()
        }
        //cell.imageView?.image = UIImage(named: "face")
        
        cell.userNickname.text = conversations[indexPath.row].display_nickname
        
        cell.userNickname.font = UIFont(name:"Avenir", size:20)
        
        //cell.userNickname.text = "wei shen me you bu xing le"
        

        
        print("need to accept? \(needToAccepts[indexPath.row])")
        
        if(needToAccepts[indexPath.row]){
            print("hello?")
            cell.acceptButton.hidden = false
            cell.acceptButton.tag = indexPath.row
            cell.acceptButton.addTarget(self, action: "acceptRequest", forControlEvents: .TouchUpInside)
        }
        else{
            cell.acceptButton.hidden = true
            
        }
        
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

    @IBAction func acceptRequest(sender: UIButton) {
        
        let friendToAdd = self.conversations[sender.tag]
        
        let uid = Firebase(url: constant.userURL).authData.uid
        let ref = Firebase(url: constant.userURL + "/users/" + uid)
        //let listRef = ref.childByAppendingPath("friends")
        
        let friendUid = friendToAdd.display_uid
        print("frientUid: \(friendUid)")
        //Add Friend
        /*
        let friend = ["uid": (friendToAdd.display_uid! as String),
                      "nickname" : friendToAdd.display_nickname,
                      "username" : friendToAdd.display_username,
                      "accepted" : true,
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
                              "accepted" : true,
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
        
        self.friendTable.reloadData()*/
        
        
    }

    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let conversationController = segue.destinationViewController as? JSQChatViewController, row = sender as? Int {
            conversationController.conversation = self.conversations[row]
        }
    }*/
}