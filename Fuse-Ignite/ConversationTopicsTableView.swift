//
//  ConversationTopicsTableView.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 17/05/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts

class ConversationTopicsTableView:  UITableView {
    
    var friendsUsernamesListArray: [String] = []

        let query : PFQuery = PFUser.query()!
//    query
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            
//            if error == nil{
//                print(objects)
//            }else{
//                print("Getting Usernames Info Failure")
//                print(error)
//        }
//}
}
