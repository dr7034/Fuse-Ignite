//
//  FollowersCell.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 08/05/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FollowersCell: UITableViewCell {

    @IBOutlet weak var userProfilePictureImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userFollowingButton: UIButton!
    
    @IBAction func followButtonTapped(sender: AnyObject) {
        
        let title = userFollowingButton.titleForState(.Normal)
        
        //follow user
        if(title == "FOLLOW") {
            let object = PFObject(className: "Followers")
            object["follower"] = PFUser.currentUser()?.username
            object["following"] = usernameLabel.text
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                if(success) {
                    self.userFollowingButton.setTitle("FOLLOWING", forState: UIControlState.Normal)
                    self.userFollowingButton.backgroundColor = .greenColor()
                } else {
                    print(error?.localizedDescription)
                }
            })
        } else {
            let query = PFQuery(className: "Followers")
            query.whereKey("follower", equalTo: (PFUser.currentUser()?.username)!)
            query.whereKey("following", equalTo: usernameLabel.text!)
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                            if (success) {
                                self.userFollowingButton.setTitle("FOLLOW", forState: UIControlState.Normal)
                                self.userFollowingButton.backgroundColor = .lightGrayColor()
                            } else {
                                print(error?.localizedDescription)
                            }
                        })
                    }
                } else {
                    print(error?.localizedDescription)
                }
            })
            
        }
    }
}
