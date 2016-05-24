//
//  OfflineViewController.swift
//  TickHelp
//
//  Created by Hongda Xiao on 5/6/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class OfflineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MPCOfflineManagerDelegate {
    let appDelagate = UIApplication.sharedApplication().delegate as! AppDelegate
    var isAdvertising: Bool!
    
    @IBOutlet weak var tblPeers: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        tblPeers.delegate = self
        tblPeers.dataSource = self

        appDelagate.mpcOfflineManager.delegate = self
        appDelagate.mpcOfflineManager.browser.startBrowsingForPeers()
        appDelagate.mpcOfflineManager.advertiser.startAdvertisingPeer()
        isAdvertising = true
        
        // Register cell classes
        tblPeers.registerClass(UITableViewCell.self, forCellReuseIdentifier: "idCellPeer")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: IBAction method implementation
    
    @IBAction func startStopAdvertising(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "", message: "Change Visibility", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var actionTitle: String
        if isAdvertising == true {
            actionTitle = "Make me invisible to others"
        }else {
            
            actionTitle = "Make me visible to others"
        }
        
        let visibilityAction: UIAlertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            if self.isAdvertising == true {
                self.appDelagate.mpcOfflineManager.advertiser.stopAdvertisingPeer()
            }else {
                self.appDelagate.mpcOfflineManager.advertiser.startAdvertisingPeer()
            }
            
            self.isAdvertising = !self.isAdvertising
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            
        }
        
        actionSheet.addAction(visibilityAction)
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
    
    // MARK: UITableView related method implementation
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelagate.mpcOfflineManager.foundPeers.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellPeer")! as UITableViewCell
        cell.textLabel?.text = appDelagate.mpcOfflineManager.foundPeers[indexPath.row].displayName
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPeer = appDelagate.mpcOfflineManager.foundPeers[indexPath.row] as MCPeerID
        
        //TODO: This function is used to send peer info we are interested in
        appDelagate.mpcOfflineManager.browser.invitePeer(selectedPeer, toSession: appDelagate.mpcOfflineManager.session, withContext: nil, timeout: 20)
        
    }
    
    // MARK: MPCManager delegate method implementation
    func foundPeer() {
        tblPeers.reloadData()
    }
    
    func lostPeer() {
        tblPeers.reloadData()
    }
    
    func invitationWasReceived(fromPeer: String) {
        
        
        let alert = UIAlertController(title: "", message: "\(fromPeer) wants to chat with you.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default)  {(alertAction) -> Void in
            
            self.appDelagate.mpcOfflineManager.invitationHandler(true, self.appDelagate.mpcOfflineManager.session)
            
        }
        
        let declineAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {(alertAction) -> Void in
            self.appDelagate.mpcOfflineManager.invitationHandler!(false,self.appDelagate.mpcOfflineManager.session)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        NSOperationQueue.mainQueue().addOperationWithBlock{ () -> Void in
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        //TODO: Currently automatically accepting connection. Need to write code on when to accept/deny connection
        //self.appDelagate.mpcManager.invitationHandler!(true, self.appDelagate.mpcManager.session)
    }
    
    
    func connectedWithPeer(peerID: MCPeerID) {
        NSOperationQueue.mainQueue().addOperationWithBlock{ () -> Void in
            self.performSegueWithIdentifier("segueOfflineChat", sender: self)}
        
    }
}
