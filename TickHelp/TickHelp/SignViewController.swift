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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPlacehoder();
        
        let myRootRef = Firebase(url:"https://tickhelp.firebaseio.com/")
        // Write data to Firebase
        myRootRef.setValue("Do you have data? You'll love Firebase.")

        // Do any additional setup after loading the view.
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
