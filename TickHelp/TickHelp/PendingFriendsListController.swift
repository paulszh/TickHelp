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
            print("these are pending friends")
            if(!accepted ){
                let needToAccept = snapshot.value.objectForKey("needToAccept") as! Bool
                //check if the user needs to accept the friend request
                let uid = snapshot.value.objectForKey("uid") as! String!
                let nickname = snapshot.value.objectForKey("nickname") as! String!
                let username = snapshot.value.objectForKey("username") as! String!
                print(nickname)
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
            cell.waitingLabel.hidden = true
        }
        else{
           cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.userInteractionEnabled = false
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
        
        let alertController = UIAlertController(title: nil, message: "Do you want to add this user as a friend?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // Nothing to do here
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Confirm Friend", style: .Default) { (action) in
            // TO-DO
            // Add code to update friend status in firebase
            let friendToAdd = self.conversations[indexPath.row]
            
           
            let friendUid = friendToAdd.display_uid
            //let listRef = ref.childByAppendingPath("friends")
            
            print("frientUid: \(friendUid)")
            
            let uid = Firebase(url: constant.userURL).authData.uid
            let ref = Firebase(url: constant.userURL + "/users/" + uid + "/friends")
            dispatch_async(dispatch_get_main_queue()){
            ref.observeEventType(.ChildAdded, withBlock: { snapshot in
                let tempUid = snapshot.value.objectForKey("uid") as! String
                print("tempUid: \(tempUid)")
                if(tempUid == friendUid){
                    let tempRef = snapshot.ref
                    tempRef.updateChildValues(["accepted": true])
                    self.conversations.removeAtIndex(indexPath.row)
                    self.friendTable.reloadData()
                
                }
            })
            }
            
            let friendRef = Firebase(url: constant.userURL + "/users/" + friendUid! + "/friends")
            friendRef.observeEventType(.ChildAdded, withBlock: { snapshot in
                let tempUid = snapshot.value.objectForKey("uid") as! String
                print("tempUid: \(tempUid)")
                if(tempUid == constant.uid){
                    let tempRef = snapshot.ref
                    tempRef.updateChildValues(["accepted": true])
                }
            })
            
        }
        alertController.addAction(OKAction)
        
        let destroyAction = UIAlertAction(title: "Delete Request", style: .Destructive) { (action) in
            print(action)
            
            let friendToAdd = self.conversations[indexPath.row]
            
            
            let friendUid = friendToAdd.display_uid
            //let listRef = ref.childByAppendingPath("friends")
            
            print("frientUid: \(friendUid)")
            
            let uid = Firebase(url: constant.userURL).authData.uid
            let ref = Firebase(url: constant.userURL + "/users/" + uid + "/friends")
            dispatch_async(dispatch_get_main_queue()){
                ref.observeEventType(.ChildAdded, withBlock: { snapshot in
                    let tempUid = snapshot.value.objectForKey("uid") as! String
                    print("tempUid: \(tempUid)")
                    if(tempUid == friendUid){
                        let tempRef = snapshot.ref
                        tempRef.removeValue()
                        self.conversations.removeAtIndex(indexPath.row)
                        self.friendTable.reloadData()
                        
                    }
                })
            }
            
            let friendRef = Firebase(url: constant.userURL + "/users/" + friendUid! + "/friends")
            friendRef.observeEventType(.ChildAdded, withBlock: { snapshot in
                let tempUid = snapshot.value.objectForKey("uid") as! String
                print("tempUid: \(tempUid)")
                if(tempUid == constant.uid){
                    let tempRef = snapshot.ref
                    tempRef.removeValue()
                }
            })
            
        }
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true) {
            // TODO
            // Add code here to delete friend request status in firebase
        }
        
    }



    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let conversationController = segue.destinationViewController as? JSQChatViewController, row = sender as? Int {
            conversationController.conversation = self.conversations[row]
        }
    }*/
}