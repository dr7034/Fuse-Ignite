//
//  UsersController.swift
//  FuseIgnite
//
//  Created by Daniel Reilly on 02/10/2015.
//  Copyright © 2015 Fuse Technology. All rights reserved.
//

import Foundation
import Parse

func myMethod() {
    let user = PFUser()
    user.username = "myUsername"
    user.password = "myPassword"
    user.email = "email@example.com"
    // other fields can be set just like with PFObject
    user["phone"] = "415-392-0202"
    
    user.signUpInBackgroundWithBlock {
        (succeeded: Bool, error: NSError?) -> Void in
        if let error = error {
            _ = error.userInfo["error"] as? NSString
            // Show the errorString somewhere and let the user try again.
        } else {
            // Hooray! Let them use the app now.
        }
    }
}