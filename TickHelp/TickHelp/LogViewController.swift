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
import GeoFire

class LogViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var ref = Firebase(url: constant.userURL)

        
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlacehoder();

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setPlacehoder(){
        
        let placeholder1 = NSAttributedString(string: "User name", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])

        let placeholder2 = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        
        username.attributedPlaceholder = placeholder1
        password.attributedPlaceholder = placeholder2

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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

                // Authentication just completed successfully :)
                // The logged in user's unique identifier
                print(authData.uid)
                
                //let alert = UIAlertController(title: "", message: "Successfully login", preferredStyle: UIAlertControllerStyle.Alert)
                //self.presentViewController(alert, animated: true, completion: nil)
                // We are now logged in
                constant.uid = authData.uid

                print("App delegate called.")
                self.performSegueWithIdentifier("loginSeg", sender: self)
                
            }
        }
        
    }
    
    @IBAction func backHomeBtnPressed(sender: AnyObject) {
        let next = self.storyboard!.instantiateViewControllerWithIdentifier("InitialViewController")
        self.presentViewController(next, animated: true, completion: nil)
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
