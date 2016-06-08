//
//  PostTableViewCell.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 25/05/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!

    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var uuidHiddenLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //double tap to like 
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(PostTableViewCell.likeTap))
        likeTap.numberOfTapsRequired = 2
        postImageView.userInteractionEnabled = true
        postImageView.addGestureRecognizer(likeTap)
    }
    
    func likeTap() {
        
        let likePic = UIImageView(image: UIImage(named: "unlikeButton"))
        likePic.frame.size.width = postImageView.frame.size.width / 1.5
        likePic.frame.size.height = postImageView.frame.size.width / 1.5
        likePic.center = postImageView.center
        likePic.alpha = 0.8
        self.addSubview(likePic)
        
        UIView.animateWithDuration(0.4) {
            likePic.alpha = 0
            likePic.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }
        
        let title = likesButton.titleForState(.Normal)
        
        if(title == "unlike") {
            let object = PFObject(className: "Likes")
            object["sender"] = PFUser.currentUser()?.username!
            object["recipient"] = uuidHiddenLabel.text!
            object.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                print("liked")
                self.likesButton.setTitle("like", forState: .Normal)
                self.likesButton.setBackgroundImage(UIImage(named: "likeButton"), forState: .Normal)
            })
        } else {
            let object = PFObject(className: "Likes")
            object["sender"] = PFUser.currentUser()?.username!
            object["recipient"] = uuidHiddenLabel.text!
            
            //delete in background with block
            object.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                self.likesButton.setTitle("unlike", forState: .Normal)
                self.likesButton.setBackgroundImage(UIImage(named: "unlikeButton"), forState: .Normal)
            })
        }
    }


    @IBAction func likesButtonClicked(sender: AnyObject) {
        
        let title = sender.titleForState(.Normal)
        
        if(title == "unlike") {
            let object = PFObject(className: "Likes")
            object["sender"] = PFUser.currentUser()?.username!
            object["recipient"] = uuidHiddenLabel.text!
            object.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                print("liked")
                self.likesButton.setTitle("like", forState: .Normal)
                self.likesButton.setBackgroundImage(UIImage(named: "likeButton"), forState: .Normal)
            })
        } else {
            let object = PFObject(className: "Likes")
            object["sender"] = PFUser.currentUser()?.username!
            object["recipient"] = uuidHiddenLabel.text!
            
            //delete in background with block
            object.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                self.likesButton.setTitle("unlike", forState: .Normal)
                self.likesButton.setBackgroundImage(UIImage(named: "unlikeButton"), forState: .Normal)
            })
        }
        
    }

}
