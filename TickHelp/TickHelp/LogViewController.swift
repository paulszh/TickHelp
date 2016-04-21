//
//  LogViewController.swift
//  TickHelp
//
//  Created by Ariel on 4/10/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase

class LogViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var ref = Firebase(url: constant.userURL)
    let appDelagate = UIApplication.sharedApplication().delegate as! AppDelegate
  //  var mpcManager: MPCManager!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setPlacehoder();
    }
    
    func setPlacehoder(){
        
        let placeholder1 = NSAttributedString(string: "User name", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])

        let placeholder2 = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        
        username.attributedPlaceholder = placeholder1
        password.attributedPlaceholder = placeholder2

    }

    @IBAction func login(sender: AnyObject) {
        ref.authUser(username.text, password:password.text) {
            error, authData in
            if error != nil {
                // Something went wrong. :(
                //print("Please check your username and password")
                //let alert = UIAlertController(title: "", message: "Please check your username and password", preferredStyle: UIAlertControllerStyle.Alert)
                //self.presentViewController(alert, animated: true, completion: nil)
            } else {
                self.appDelagate.mpcManager = MPCManager()
                // Authentication just completed successfully :)
                // The logged in user's unique identifier
                print(authData.uid)
                //let alert = UIAlertController(title: "", message: "Successfully login", preferredStyle: UIAlertControllerStyle.Alert)
                //self.presentViewController(alert, animated: true, completion: nil)
                // We are now logged in
                constant.uid = authData.uid;
                self.performSegueWithIdentifier("loginSeg", sender: self)
                
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
