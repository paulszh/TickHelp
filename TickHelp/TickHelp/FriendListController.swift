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
        
        friendName = []
        friendId = []
        
        let uid = Firebase(url: constant.userURL).authData.uid
        let ref = Firebase(url: constant.userURL + "/users/" + uid + "/friends")
        
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            
                let uid = snapshot.value.objectForKey("uid") as! String!
                
                self.friendId.append(uid)
                
                let name = snapshot.value.objectForKey("name") as! String!
                
                self.friendName.append(name)
            
                print("Name: \(name)")
            
            self.friendTable.reloadData()
        })

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendId.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell")! as UITableViewCell
        
        if(friendName.count <= indexPath.row) {
            return UITableViewCell()
        }
        
        cell.textLabel!.text = friendName[indexPath.row]

        cell.textLabel!.font = UIFont(name:"Avenir", size:20)
        
        cell.imageView?.image = UIImage(named: "face")

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
