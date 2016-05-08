//
//  DisplayNameController.swift
//  TickHelp
//
//  Created by Hongda Xiao on 5/7/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit

class DisplayNameController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var DisplayNameTextField: UITextField!
    var nameToDisplay = ""
    let appDelagate = UIApplication.sharedApplication().delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayNameTextField.delegate = self
        
        setPlaceholder();
    }
    
    func setPlaceholder(){
        let displayNameHolder = NSAttributedString(string: "Enter display name here", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        
        DisplayNameTextField.attributedPlaceholder = displayNameHolder
    }
    func textFieldDidEndEditing(textField: UITextField) {

        nameToDisplay = textField.text!
        constant.displayname = textField.text!
     //   self.appDelagate.mpcOfflineManager = MPCOfflineManager()
     //    print("nameToDisplay: \(nameToDisplay)")
    }
    
    @IBAction func ConfirmDisplayNameBtn(sender: UIButton) {
        constant.displayname = nameToDisplay
  //      print("display name is now: \(nameToDisplay)")
  //      print("constant name is now: \(constant.displayname)")
  //      self.appDelagate.mpcOfflineManager = MPCOfflineManager()

    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }

    
}
