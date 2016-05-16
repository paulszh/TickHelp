//
//  OnlineUserTableViewController.swift
//  TickHelp
//
//  Created by paulszh on 5/9/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit
import Firebase

class OnlineUserTableViewController: UITableViewController {
    
    let user = "cell"
    let usersRef = Firebase(url: constant.userURL + "/users")
    let userOnline = Firebase(url: constant.userURL + "/online")
    var currentUsers: [String] = [String]()
    // MARK: Properties
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userOnline.observeEventType(.ChildAdded, withBlock: { (snap: FDataSnapshot!) in
            
            // Add the new user to the local array
            self.currentUsers.append(snap.value as! String)
            
            // Get the index of the current row
            let row = self.currentUsers.count - 1
            
            // Create an NSIndexPath for the row
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            
            // Insert the row for the table with an animation
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            
        })
        
        // Create a listener for the delta deletions to animate removes from the table view
        userOnline.observeEventType(.ChildRemoved, withBlock: { (snap: FDataSnapshot!) -> Void in
            
            // Get the email to find
            let emailToFind: String! = snap.value as! String
            
            // Loop to find the email in the array
            for(index, email) in self.currentUsers.enumerate() {
                
                // If the email is found, delete it from the table with an animation
                if email == emailToFind {
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    self.currentUsers.removeAtIndex(index)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
                
            }
            
        })
        
        /*usersRef.observeEventType(.ChildAdded, withBlock: { (snap: FDataSnapshot!) in
            
            print("Enter observeEventType")
            // Add the new user to the local array
            var curr = ""
            for rest in snap.children{
                if(rest.key == "nickname"){
                    //print("Enter if statement")
                    curr = rest.value
                    print(curr)
                }
            }
            
            self.currentUsers.append(curr)
        
            // Get the index of the current row
            let row = self.currentUsers.count - 1
            
            // Create an NSIndexPath for the row
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            
            // Insert the row for the table with an animation
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            
        })*/
        
        // Create a listener for the delta deletions to animate removes from the table view
        /*usersRef.observeEventType(.ChildRemoved, withBlock: { (snap: FDataSnapshot!) -> Void in
            
            
            print("Enter observeEventType")
            // Get the email to find
            var curr = ""
            for rest in snap.children{
                if(rest.key == "email"){
                    print("Enter if statement 2")
                    curr = rest.value
                    print(curr)
                }
            }
            //let emailToFind: String! = snap.value as! String
            
            // Loop to find the email in the array
            for(index, email) in self.currentUsers.enumerate() {
                
                // If the email is found, delete it from the table with an animation
                if email == curr {
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    self.currentUsers.removeAtIndex(index)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
                
            }
            
        })*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(user) as UITableViewCell!
        let onlineUserEmail = currentUsers[indexPath.row]
        cell.textLabel?.text = onlineUserEmail
        return cell
    }
    

}
