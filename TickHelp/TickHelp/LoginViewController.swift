//
//  ViewController.swift
//  TickHelp
//
//  Created by Ariel on 4/9/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit

import VideoSplashKit
import Firebase

class ViewController: VideoSplashViewController {
    
    @IBOutlet weak var LogIn: UIButton!
    @IBOutlet weak var SignUp: UIButton!
    var ref = Firebase(url: constant.userURL)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Video
        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("test3", ofType: "mp4")!)
        self.videoFrame = view.frame
        self.fillMode = .ResizeAspectFill
        self.alwaysRepeat = true
        self.sound = true
        self.startTime = 4.0
        self.duration = 6.0
        self.alpha = 0.4
        self.backgroundColor = UIColor.blackColor()
        self.contentURL = url
        self.restartForeground = true
        
        
        //Buttons
        LogIn.layer.cornerRadius = 5
        LogIn.layer.borderWidth = 1
        LogIn.layer.borderColor = UIColor.whiteColor().CGColor

        
        SignUp.layer.cornerRadius = 5
        SignUp.layer.borderWidth = 1
        SignUp.layer.borderColor = UIColor.whiteColor().CGColor
        
        
    }

    
//    override func viewDidAppear(animated: Bool){
//        
//        super.viewWillAppear(animated);
//        
//        //Auto log in
//        if( ref.authData != nil){
//            print("Successfully login ")
//             print("User " + ref.authData.uid + " is logged in with " + ref.authData.provider)
//            performSegueWithIdentifier("autoSeg", sender: self)
//        }
//    }

}

