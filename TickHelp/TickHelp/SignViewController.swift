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
    let firebase = Firebase(url: "https://tickhelp1234.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPlacehoder();
        
        //let myRootRef = Firebase(url:"https://tickhelp.firebaseio.com/")
        // Write data to Firebase
        
        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @IBAction func register(sender: AnyObject) {
        self.firebase.createUser(username.text, password: password.text) { (error: NSError!) in
            //user is created successfully
            if error == nil {
                self.firebase.authUser(self.username.text, password: self.password.text,
                                       withCompletionBlock: { (error, auth) -> Void in
                                        
                                        print(auth.uid)
                                        // Create a new user dictionary accessing the user's info
                                        // provided by the authData parameter
                                        let newUser = [
                                            "uid": auth.uid,
                                            "username": self.username.text,
                                            "nickname": self.nickname.text,
                                            //the password need to be hashed
                                            "password": self.password.text,
                                            "image_path": "",
                                            "credit" : "0",
                                            "device": UIDevice.currentDevice().identifierForVendor!.UUIDString
                                        ]
                                        
                                        if(auth.uid != nil){
                                            self.firebase.childByAppendingPath("users")
                                                .childByAppendingPath(auth.uid).setValue(newUser)
                                            constant.uid = auth.uid;
                                            self.performSegueWithIdentifier("signupSeg", sender: self)
                                        }
                })
                
            }
            else{
                print("Authentication Failed");
            }
        }
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
