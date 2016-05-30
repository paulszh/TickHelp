//
//  FriendListController.swift
//  TickHelp
//
//  Created by Hongda Xiao on 4/17/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit
import Firebase

class FriendListController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var friendTable: UITableView!
    
    var friendName : [String!] = []
    var friendId : [String!] = []

    
    var conversations = [Conversation]()
    
    var userImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        friendTable.delegate = self
        friendTable.dataSource = self
        
        // Register cell classes
        //friendTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "idCellPeer")
        
        //Get friend list
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Get friend list
        
        
        conversations = []
        
        let uid = Firebase(url: constant.userURL).authData.uid
        let ref = Firebase(url: constant.userURL + "/users/" + uid + "/friends")
        
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            
            //check if the friend request has been accepted
            let accepted = snapshot.value.objectForKey("accepted") as! Bool
            if(accepted){
                let uid = snapshot.value.objectForKey("uid") as! String!
                let nickname = snapshot.value.objectForKey("nickname") as! String!
                let username = snapshot.value.objectForKey("username") as! String!
                
                let friendRef = Firebase(url: constant.userURL + "/users/" + uid)
                print("friendRef\(friendRef)")
                /*get friend user image --> bu zhi dao wei shen me bu jin zhe ge block
                friendRef.observeEventType(.Value, withBlock: { snapshot in
                    print("Hello?")
                    let base64EncodedString = snapshot.value.objectForKey("image_path") as! String
                    self.userImages.append(base64EncodedString)
                    
                    print(self.userImages.count)
                    
                })*/
                
                
            
                let newFriend = Conversation(display_nickname: nickname, display_username: username, display_uid: uid, latestMessage: username, isRead: false)
                self.conversations.append(newFriend)
                print("count: \(uid)")
                print("count1: \(self.conversations.count)")
            
                self.friendTable.reloadData()
            }
        })
        
    }
    
    @IBAction func logOutBtnPressed(sender: UIBarButtonItem) {
        let next = self.storyboard!.instantiateViewControllerWithIdentifier("InitialViewController")
        self.presentViewController(next, animated: true, completion: nil)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.friendTable.dequeueReusableCellWithIdentifier("friendCell", forIndexPath:indexPath) as! FriendCell
        
        if(conversations.count <= indexPath.row) {
            return UITableViewCell()
        }
    
        
        cell.userNickname.text = conversations[indexPath.row].display_nickname
        cell.userNickname.font = UIFont(name:"Avenir", size:20)
        
        cell.userImage.image = UIImage(named: "face")
        /*
        let imageRetrieve = NSData(base64EncodedString: userImages[indexPath.row] ,
                                   options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedImage = UIImage(data:imageRetrieve!)
        if(decodedImage != nil){
            cell.userImage.image = decodedImage
        }
        else{
            cell.userImage.image = UIImage(named: "face")
        }*/
        
        
        
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
        /*
        let alertController = UIAlertController(title: nil, message: "What would you like to do?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Chat", style: .Default) { (action) in
            // need to know where we entered the conversation
            constant.enter_chat_origin = "Friends"
            self.performSegueWithIdentifier("FriendChatSegue", sender: indexPath.row)
            
        }
        alertController.addAction(OKAction)
        
        let supportAction = UIAlertAction(title: "ThumbsUp!", style: .Default) { (action) in
            
        }
        alertController.addAction(supportAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }*/
        let alertController = UIAlertController(title: nil, message: "What would you like to do?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // Nothing to do here
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Chat Now", style: .Default) { (action) in
            
            constant.enter_chat_origin = "Friends"
            self.performSegueWithIdentifier("FriendChatSegue", sender: indexPath.row)
            // TO-DO
            // Add code to update friend status in firebase
        }
        alertController.addAction(OKAction)
        
        let destroyAction = UIAlertAction(title: "Remove Friend", style: .Destructive) { (action) in
            print(action)
            let friendToAdd = self.conversations[indexPath.row]
            
            
            let friendUid = friendToAdd.display_uid
            //let listRef = ref.childByAppendingPath("friends")
            
            print("frientUid: \(friendUid)")
            
            let uid = Firebase(url: constant.userURL).authData.uid
            let ref = Firebase(url: constant.userURL + "/users/" + uid + "/friends")
            dispatch_async(dispatch_get_main_queue()){
                ref.observeEventType(.ChildChanged, withBlock: { snapshot in
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
        
        
        
        
        
    //    performSegueWithIdentifier("FriendChatSegue", sender: indexPath.row)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let conversationController = segue.destinationViewController as? JSQChatViewController, row = sender as? Int {
            conversationController.conversation = self.conversations[row]
        }
    }
}