//
//  user.swift
//  TickHelp
//
//  Created by paulszh on 5/9/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import Foundation
import Firebase

struct user {
    let uid: String
    let email: String
    
    // Initialize from Firebase
    init(authData: FAuthData) {
        uid = authData.uid
        email = authData.providerData["email"] as! String
    }
    
    // Initialize from arbitrary data
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}