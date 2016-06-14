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
    
    @IBAction func followButtonTapped(_ sender: AnyObject) {
        
        let title = userFollowingButton.title(for: UIControlState())
        
        //follow user
        if(title == "FOLLOW") {
            let object = PFObject(className: "Followers")
            object["follower"] = PFUser.current()?.username
            object["following"] = usernameLabel.text
            
            object.saveInBackground({ (success:Bool, error:NSError?) in
                if(success) {
                    self.userFollowingButton.setTitle("FOLLOWING", for: UIControlState())
                    self.userFollowingButton.backgroundColor = .green()
                } else {
                    print(error?.localizedDescription)
                }
            })
            
            
        } else {
            let query = PFQuery(className: "Followers")
            query.whereKey("follower", equalTo: (PFUser.current()?.username)!)
            query.whereKey("following", equalTo: usernameLabel.text!)
            query.findObjectsInBackground({ (objects: [PFObject]?, error: NSError?) in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackground({ (success:Bool, error:NSError?) in
                            if (success) {
                                self.userFollowingButton.setTitle("FOLLOW", for: UIControlState())
                                self.userFollowingButton.backgroundColor = .lightGray()
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
