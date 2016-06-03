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
        let ref = Firebase(url: constant.userURL + "/users/")
        
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            let uid = snapshot.value.objectForKey("uid") as! String!
            let nickname = snapshot.value.objectForKey("nickname") as! String!
            let username = snapshot.value.objectForKey("username") as! String!
            let score = snapshot.value.objectForKey("score") as! Int!
            let imagePath = snapshot.value.objectForKey("image_path") as! String!
            let creditPath = snapshot.value.objectForKey("credit") as! Int
            print("The current credit is:     \(creditPath)")
            

            let user = Rank(display_nickname: nickname, display_username: username, display_uid: uid, latestMessage: username, isRead: false, imageUrl: imagePath, score: score, credit: creditPath)
            self.conversations.append(user)
            
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
      //  print(conversations[indexPath.row].credit)
        cell.userCredit!.text = String(conversations[indexPath.row].credit!)
        
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
    
    @IBAction func logOutBtnPressed(sender: UIBarButtonItem) {
        // Delete the corresponding location in Firebase
        /*
        let ref = Firebase(url: constant.userURL + "/locations/")
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            if(snapshot.value.objectForKey("currLoc") as! String == constant.uid){
                ref.childByAppendingPath(snapshot.value.objectForKey("currLoc")as! String).setValue("")
            }
        }) */
        let next = self.storyboard!.instantiateViewControllerWithIdentifier("InitialViewController")
        self.presentViewController(next, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        if let conversationController = segue.destinationViewController as? JSQChatViewController, row = sender as? Int {
            //    conversationController.conversation = self.conversations[row]
        }*/
    }
}