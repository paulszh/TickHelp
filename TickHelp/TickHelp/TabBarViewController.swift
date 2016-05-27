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
        UITabBar.appearance().barTintColor = UIColor.whiteColor()
        UITabBar.appearance().tintColor = UIColor.blackColor()
        
        if(constant.enter_chat_origin == "Friends"){
            self.selectedIndex = 1
        }
        else if(constant.enter_chat_origin == "NearbyUsers"){
            self.selectedIndex = 0
        }
        
        /*let item0 = self.tabBar.items![0] as UITabBarItem
        item0.image = UIImage(named: "chat")!
        item0.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        let item1 = self.tabBar.items![1] as UITabBarItem
        item1.image = UIImage(named: "ID")!
        item1.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        let item2 = self.tabBar.items![2] as UITabBarItem
        item2.image = UIImage(named: "Groups")!
        item2.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        let item3 = self.tabBar.items![3] as UITabBarItem
        item3.image = UIImage(named: "Queen")!
        item3.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)*/
        
        
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
