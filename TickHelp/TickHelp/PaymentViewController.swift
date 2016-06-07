//
//  PaymentViewController.swift
//  TickHelp
//
//  Created by Hongda Xiao on 6/3/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit

class PaymentViewController: UITableViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet var textFields: [UITextField]!
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        return true
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        let next = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabBarController")
        
        self.presentViewController(next, animated: true, completion: nil)
    }
    @IBAction func donate(sender: AnyObject) {
        
        
        let alertController = UIAlertController(title: nil, message: "Are you sure to send this tip?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // Nothing to do here
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Send Tip", style: .Default) { (action) in
            // why is this not showing????
       //     SweetAlert().showAlert("Payment Received!", subTitle: "A confirmation has been sent to your email", style: AlertStyle.Warning, buttonTitle:"OK", buttonColor:UIColor.grayColor() )
           
            let next = self.storyboard!.instantiateViewControllerWithIdentifier("MainTabBarController")
            self.presentViewController(next, animated: true, completion: nil)
            return;
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) {
            // TODO
            // Add code here to delete friend request status in firebase
        }
    }

}
