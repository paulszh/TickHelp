//
//  DisplayNameController.swift
//  TickHelp
//
//  Created by Hongda Xiao on 5/7/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit

class DisplayNameController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var confirm: UIButton!
    @IBOutlet weak var DisplayNameTextField: UITextField!
    let appDelagate = UIApplication.sharedApplication().delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayNameTextField.delegate = self
        setPlaceholder();
        
        confirm.layer.cornerRadius = 5
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func setPlaceholder(){
        let displayNameHolder = NSAttributedString(string: "Enter display name here", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        
        DisplayNameTextField.attributedPlaceholder = displayNameHolder
    }
    
    @IBAction func ConfirmDisplayNameBtn(sender: UIButton) {
        textFieldDidEndEditing(DisplayNameTextField)
        self.appDelagate.mpcOfflineManager = MPCOfflineManager()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        constant.displayname = textField.text!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
}
