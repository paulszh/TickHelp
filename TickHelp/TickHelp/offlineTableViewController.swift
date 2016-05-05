//
//  offlineTableViewController.swift
//  TickHelp
//
//  Created by Ariel on 5/5/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class offlineTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MPCManagerDelegate {
    
    @IBOutlet weak var peers: UITableView!
    
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
        peers.registerClass(UITableViewCell.self, forCellReuseIdentifier: "offCell")
        print("wowo")
        
        //print("peer: \(self.peerName)")
        
       // peers.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
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

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("wowo4")
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("wowo2")
        return appDelagate.mpcManager.foundPeers.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("wowo3")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("offCell")! as UITableViewCell
                
      cell.textLabel?.text =  self.appDelagate.mpcManager.foundPeers[indexPath.row].displayName as String!
        
       // cell.textLabel?.text = "hi"
        cell.imageView?.image = UIImage(named: "face")
        
        //cell.textLabel?.text = appDelagate.mpcManager.foundPeers[indexPath.row].displayName
        
        cell.textLabel!.font = UIFont(name:"Avenir", size:20)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        print("wowo5")
        return 70.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("wowo6")
        let selectedPeer = appDelagate.mpcManager.foundPeers[indexPath.row] as MCPeerID
        
         self.appDelagate.mpcManager.browser.invitePeer(selectedPeer, toSession: self.appDelagate.mpcManager.session, withContext: nil, timeout: 20)
        
        
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
    }
    
    func connectedWithPeer(peerID: MCPeerID) {
        NSOperationQueue.mainQueue().addOperationWithBlock{ () -> Void in
            
            print("here")
            self.performSegueWithIdentifier("segueChat", sender: self)}
        
    }

}
