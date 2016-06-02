//
//  switchFriendRequestsController.swift
//  TickHelp
//
//  Created by Hongda Xiao on 5/24/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit
import Firebase

class switchFriendRequestsController: UIViewController {
    
    weak var currentViewController: UIViewController?

    @IBOutlet weak var containerView: UIView!
    
    let appDelagate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    
    override func viewDidLoad() {
        self.currentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("confirmedFriendList")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
        self.addChildViewController(self.currentViewController!)
        
        super.viewDidLoad()
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    @IBAction func logOutBtnPressed(sender: UIBarButtonItem) {
        // Delete the corresponding location in Firebase
        let ref = Firebase(url: constant.userURL + "/locations/")
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            if(snapshot.value.objectForKey("currLoc") as! String == constant.uid){
                ref.childByAppendingPath(snapshot.value.objectForKey("currLoc")as! String).setValue("")
            }
        })
        let next = self.storyboard!.instantiateViewControllerWithIdentifier("InitialViewController")
        self.presentViewController(next, animated: true, completion: nil)
    }
    
    @IBAction func showComponent(sender: UISegmentedControl) {  
        if sender.selectedSegmentIndex == 0 {
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("confirmedFriendList")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        } else {
            self.appDelagate.mpcOfflineManager = MPCOfflineManager()
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("pendingFriendList")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            
            self.currentViewController = newViewController
        }
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            },
                                   completion: { finished in
                                    oldViewController.view.removeFromSuperview()
                                    oldViewController.removeFromParentViewController()
                                    newViewController.didMoveToParentViewController(self)
        })
    }
    
    
}