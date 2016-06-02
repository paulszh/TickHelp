//
//  RankListViewController.swift
//  TickHelp
//
//  Created by Hongda Xiao on 6/2/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit
import Firebase

class RankListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    //@IBOutlet weak var friendTable: UITableView!
    
    @IBOutlet weak var friendTable: UITableView!
    var friendName : [String!] = []
    var friendId : [String!] = []
    
    
    
    var conversations = [Rank]()
    var imgUrl = String()
    
    var userImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendTable.delegate = self
        friendTable.dataSource = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        self.conversations = []

        
        self.friendTable.reloadData()
      //  let uid = Firebase(url: constant.userURL).authData.uid
     //   let ref = Firebase(url: constant.userURL + "/users/" + uid + "/friends")
        let ref = Firebase(url: constant.userURL + "/users/")
        
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
        /*    //check if the friend request has been accepted
            let accepted = snapshot.value.objectForKey("accepted") as! Bool
            if(accepted){
                let uid = snapshot.value.objectForKey("uid") as! String!
                let nickname = snapshot.value.objectForKey("nickname") as! String!
                let username = snapshot.value.objectForKey("username") as! String!
                
                
                let friendRef = Firebase(url: constant.userURL + "/users/" + uid)
                print("friendRef......... \(friendRef)")
                
                friendRef.observeEventType(.Value, withBlock: { snapshot in
                    
                    
                    
                    //     self.imgUrl = snapshot.value.objectForKey("image_path") as! String
                    let imagePath = snapshot.value.objectForKey("image_path") as! String
                    print("Make a friend with the image url:     \(self.imgUrl)")
                    let newFriend = Friend(display_nickname: nickname, display_username: username, display_uid: uid, latestMessage: username, isRead: false, imageUrl: imagePath)
                    //          let newFriend = Friend(display_nickname: nickname, display_username: username, display_uid: uid, latestMessage: username, isRead: false, imageUrl: imagePath)
                    
                    print("appending a new friend... ")
                    self.conversations.append(newFriend)
                    
                    self.friendTable.reloadData()
                    
                })
            }*/
            let uid = snapshot.value.objectForKey("uid") as! String!
            let nickname = snapshot.value.objectForKey("nickname") as! String!
            let username = snapshot.value.objectForKey("username") as! String!
            let score = snapshot.value.objectForKey("score") as! Int!
            let imagePath = snapshot.value.objectForKey("image_path") as! String!
            
            print("This imagePath is:     \(imagePath)")
            
            
            let newFriend = Rank(display_nickname: nickname, display_username: username, display_uid: uid, latestMessage: username, isRead: false, imageUrl: imagePath, score: score)
            self.conversations.append(newFriend)
            
            // Sort the array by the order of credits received.
            self.conversations.sortInPlace {(rank1:Rank, rank2:Rank) -> Bool in
                rank1.score > rank2.score
            }
            
            self.friendTable.reloadData()

            
        })
        
        
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        
        let cell = self.friendTable.dequeueReusableCellWithIdentifier("rankCell", forIndexPath:indexPath) as! RankingCell
        
        if(conversations.count <= indexPath.row) {
            return UITableViewCell()
        }

        
        cell.userNickname.text = conversations[indexPath.row].display_nickname
        cell.userNickname.font = UIFont(name:"Avenir", size:20)
        
        // Display the relative user rank number here.
        cell.rankNumber.text = String(indexPath.row + 1)
        if(indexPath.row + 1 <= 3){
            cell.rankNumber.font = UIFont(name:"Avenir", size:20)
            cell.rankNumber.highlightedTextColor = UIColor.redColor()
        }
        
        
        let imageRetrieve = NSData(base64EncodedString: conversations[indexPath.row].imageUrl! ,
                                   options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        
        let decodedImage = UIImage(data:imageRetrieve!)
        
        
        if(decodedImage != nil){
            cell.userImage.image = decodedImage
        }
        else{
            cell.userImage.image = UIImage(named: "face")
        }
        
        
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        if let conversationController = segue.destinationViewController as? JSQChatViewController, row = sender as? Int {
            //    conversationController.conversation = self.conversations[row]
        }*/
    }
}