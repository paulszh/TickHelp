
//
//  offlineChatViewController.swift
//  TickHelp
//
//  Created by Ariel on 4/9/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import Firebase

class offlineChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MPCManagerDelegate {

    @IBOutlet weak var peers: UITableView!
    
    let refAll = Firebase(url: constant.userURL + "/users/")
    var ref = Firebase(url: constant.userURL + "/users/" + constant.uid)
    
    let appDelagate = UIApplication.sharedApplication().delegate as! AppDelegate
    var isAdvertising: Bool!
    
    var peerName: String!
    var peerId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        peers.delegate = self
        peers.dataSource = self
        
        appDelagate.mpcManager.delegate = self
        appDelagate.mpcManager.browser.startBrowsingForPeers()
        appDelagate.mpcManager.advertiser.startAdvertisingPeer()
        isAdvertising = true
        
        // Register cell classes
        peers.registerClass(UITableViewCell.self, forCellReuseIdentifier: "idCellPeer")
        
        //print("peer: \(self.peerName)")
        
        peers.separatorStyle = UITableViewCellSeparatorStyle.None

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func visibility(sender: AnyObject) {
        
        let actionSheet = UIAlertController(title: "", message: "Change Visibility", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var actionTitle: String
        if isAdvertising == true {
            actionTitle = "Make me invisible to others"
        }else {
            
            actionTitle = "Make me visible to others"
        }
        
        let visibilityAction: UIAlertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            if self.isAdvertising == true {
                self.appDelagate.mpcManager.advertiser.stopAdvertisingPeer()
            }else {
                self.appDelagate.mpcManager.advertiser.startAdvertisingPeer()
            }
            
            self.isAdvertising = !self.isAdvertising
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            
        }
        
        actionSheet.addAction(visibilityAction)
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    @IBAction func LogOut(sender: AnyObject) {
        ref.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        performSegueWithIdentifier("logOutSeg", sender: self)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelagate.mpcManager.foundPeers.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellPeer")! as UITableViewCell
        
        print("CEEEEEEEEEEELLLLLLLLLLLL")
        
        
        refAll.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            print(snapshot.childrenCount) // I got the expected number of items
            
            let enumerator = snapshot.children
            
            while let rest = enumerator.nextObject() as? FDataSnapshot {
                
                
                let str = rest.value.objectForKey("device") as! String!
                
                if (str != nil && str == self.appDelagate.mpcManager.foundPeers[indexPath.row].displayName){
                    print(str)
                    cell.textLabel?.text = rest.value.objectForKey("nickname") as! String!
                    print()
                    cell.imageView?.image = UIImage(named: "face")

                }
            }
        })
        
        //cell.textLabel?.text = appDelagate.mpcManager.foundPeers[indexPath.row].displayName
        
        cell.textLabel!.font = UIFont(name:"Avenir", size:20)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPeer = appDelagate.mpcManager.foundPeers[indexPath.row] as MCPeerID
        
        refAll.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            print(snapshot.childrenCount) // I got the expected number of items
            
            let enumerator = snapshot.children
            
            while let rest = enumerator.nextObject() as? FDataSnapshot {
                
                let str = rest.value.objectForKey("device") as! String!
                
                if (str != nil && str == self.appDelagate.mpcManager.foundPeers[indexPath.row].displayName){
                    print(str)
                    self.peerName = rest.value.objectForKey("nickname") as! String!
                    self.peerId = rest.value.objectForKey("uid") as! String!
                    
                    self.appDelagate.mpcManager.browser.invitePeer(selectedPeer, toSession: self.appDelagate.mpcManager.session, withContext: nil, timeout: 20)
                    
                    break

                }
            }
        })
        
        //TODO: This function is used to send peer info we are interested in
    }
    
    // MARK: MPCManager delegate method implementation
    func foundPeer() {
        peers.reloadData()
    }
    
    func lostPeer() {
        peers.reloadData()
    }
    
    func invitationWasReceived(fromPeer: String) {
        
    
        refAll.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            print(snapshot.childrenCount) // I got the expected number of items
            
            let enumerator = snapshot.children
            
            while let rest = enumerator.nextObject() as? FDataSnapshot {
                
                let str = rest.value.objectForKey("device") as! String!
               
                
                if (str != nil && str == fromPeer){
                    self.peerName = rest.value.objectForKey("nickname") as! String!
                    self.peerId = rest.value.objectForKey("uid") as! String!
                    
                    print("peerSeted: \(self.peerName)")

                    
                    let alert = UIAlertController(title: "", message: "\(self.peerName) wants to chat with you.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default)  {(alertAction) -> Void in
                        
                        self.appDelagate.mpcManager.invitationHandler(true, self.appDelagate.mpcManager.session)
                    }
                    
                    let declineAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {(alertAction) -> Void in
                        self.appDelagate.mpcManager.invitationHandler!(false,self.appDelagate.mpcManager.session)
                    }
                    
                    alert.addAction(acceptAction)
                    alert.addAction(declineAction)
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock{ () -> Void in
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                    break;
                }
            }
        })
    
        //TODO: Currently automatically accepting connection. Need to write code on when to accept/deny connection
        //self.appDelagate.mpcManager.invitationHandler!(true, self.appDelagate.mpcManager.session)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueChat") {
            
            print("peer: \(self.peerName)")
            
            let dest: chatViewController = segue.destinationViewController as! chatViewController
            
            dest.peerName = self.peerName
            dest.peerId = self.peerId

            // pass data to next view
        }
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        NSOperationQueue.mainQueue().addOperationWithBlock{ () -> Void in
            
            print("here")
            self.performSegueWithIdentifier("segueChat", sender: self)}
        
    }
}
