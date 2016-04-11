//
//  TabBarViewController.swift
//  TickHelp
//
//  Created by Ariel on 4/10/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UITabBar.appearance().barTintColor = UIColor.blackColor()
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
//        let myTabBarItem = self.tabBar.items![1] as UITabBarItem
//        myTabBarItem.image = UIImage(named: "Home")!
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
