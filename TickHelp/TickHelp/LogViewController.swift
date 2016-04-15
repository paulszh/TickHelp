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
        let ref = Firebase(url: "https://tickhelp.firebaseio.com/")
        ref.authUser(username.text, password: password.text,
                     withCompletionBlock: { error, authData in
                        if error != nil {
                            print("Please check your username and password")
                            // There was an error logging in to this account
                        } else {
                            print("Successfully login ")
                            self.performSegueWithIdentifier("loginSeg", sender: self)
                            // We are now logged in
                        }
        })
        
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
