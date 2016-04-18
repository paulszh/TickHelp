//
//  SignViewController.swift
//  TickHelp
//
//  Created by Ariel on 4/10/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit
import Firebase

class SignViewController: UIViewController {
    
    
    
    @IBOutlet weak var nickname: UITextField!
    
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    let firebase = Firebase(url:constant.userURL)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPlacehoder();
        
        //let myRootRef = Firebase(url:"https://tickhelp.firebaseio.com/")
        // Write data to Firebase
        
        // Do any additional setup after loading the view.
    }
    @IBAction func register(sender: AnyObject) {
        self.firebase.createUser(username.text, password: password.text) { (error: NSError!) in
            // 2
            if error == nil {
                // 3
                self.firebase.authUser(self.username.text, password: self.password.text,
                                  withCompletionBlock: { (error, auth) -> Void in
                                    print(auth.uid)
                                    // Create a new user dictionary accessing the user's info
                                    // provided by the authData parameter
                                    let newUser = [
                                        "username": auth.uid,
                                        "nickname": self.nickname.text,
                                        "password": self.password.text,
                                        "credit" : "0",
                                    ]
                                    // Create a child path with a key set to the uid underneath the "users" node
                                    // This creates a URL path like the following:
                                    //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
                                    if(auth.uid != nil){
                                        self.firebase.childByAppendingPath("users")
                                            .childByAppendingPath(auth.uid).setValue(newUser)
                                        self.performSegueWithIdentifier("signupSeg", sender: self)
                                    }
                                    // 4
                })
                
            }
            else{
                print("Failed");
            }
        }
        
        
        
        
    }
    
    func setPlacehoder(){
        
        let placeholder1 = NSAttributedString(string: "User name", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        let placeholder2 = NSAttributedString(string: "Nick name", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        let placeholder3 = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        
        username.attributedPlaceholder = placeholder1
        nickname.attributedPlaceholder = placeholder2
        password.attributedPlaceholder = placeholder3
        
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
