//
//  ProfileVisitorViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 09/05/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import ParseUI

var visitorName = [String]()

class ProfileVisitorViewController: UIViewController {
    
    
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userJobTitleLabel: UILabel!
    @IBOutlet weak var userCompanyLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userBioTextView: UITextView!
    @IBOutlet weak var userNetworkingObjectivesTextView: UITextView!
    @IBOutlet weak var userFollowingCountLabel: UILabel!
    @IBOutlet weak var userFollowersCountLabel: UILabel!
    @IBOutlet weak var userScheduledEventsCountLabel: UILabel!
    @IBOutlet weak var userFollowButton: UIButton!
    
    //table views
    @IBOutlet weak var conversationTopicsTableView: UITableView!
    @IBOutlet weak var eventObjectivesTableView: UITableView!
    @IBOutlet weak var motivationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //top title
        self.navigationItem.title = "@" + visitorName.last!
        
        let infoQuery = PFQuery(className: "_User")
        infoQuery.whereKey("username", equalTo: visitorName.last!)
        infoQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if(error == nil) {
                if objects!.isEmpty {
                    print("wrong user")
                }
                
                //find related user info
                for object in objects! {
                    self.userFullNameLabel.text = object["fullName"] as? String
                    self.userBioTextView.text = object["userBio"] as? String
                    self.userBioTextView.sizeToFit()
                    self.userCompanyLabel.text = object["companyName"] as? String
                    self.userJobTitleLabel.text = object["jobTitle"] as? String
                    self.userNetworkingObjectivesTextView.text = object["networkingObjectives"] as? String
                    self.userBioTextView.sizeToFit()
                    let profilePicFile: PFFile = (object.objectForKey("profile_picture") as? PFFile)!
                    profilePicFile.getDataInBackgroundWithBlock({ (data: NSData?, error:NSError?) in
                        self.profilePictureImageView.image = UIImage(data: data!)
                        self.loadProfilePictureDimensions()
                    })
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    
        let followQuery = PFQuery(className: "Followers")
        followQuery.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
        followQuery.whereKey("following", equalTo: visitorName.last!)
        followQuery.countObjectsInBackgroundWithBlock({ (count: Int32, error: NSError?) in
            if(error == nil) {
                if count == 0 {
                    self.userFollowButton.setTitle("Follow +", forState: .Normal)
                    self.userFollowButton.backgroundColor = .blueColor()
                } else {
                    self.userFollowButton.setTitle("Following", forState: .Normal)
                    self.userFollowButton.backgroundColor = .greenColor()
                }
            } else {
                print(error?.localizedDescription)
            }
        })
        
        //count users who are followers
        let followers = PFQuery(className: "Followers")
        followers.whereKey("following", equalTo: visitorName.last!)
        followers.countObjectsInBackgroundWithBlock ({ (count: Int32, error: NSError?) in
            if (error == nil) {
                self.userFollowersCountLabel.text = "\(count)"
            } else {
                print( error?.localizedDescription)
            }
        })
        
        //count users following
        let following = PFQuery(className: "Followers")
        following.whereKey("follower", equalTo: visitorName.last!)
        following.countObjectsInBackgroundWithBlock ({ (count: Int32, error: NSError?) in
            if (error == nil) {
                self.userFollowingCountLabel.text = "\(count)"
            } else {
                print( error?.localizedDescription)
            }
        })
        
        //tap to get followers
        let followersTap = UITapGestureRecognizer(target: self, action: "followersTap")
        followersTap.numberOfTapsRequired = 1
        self.userFollowersCountLabel.userInteractionEnabled = true
        self.userFollowersCountLabel.addGestureRecognizer(followersTap)
        
        //tap to get users following
        let followingTap = UITapGestureRecognizer(target: self, action: "followingTap")
        followingTap.numberOfTapsRequired = 1
        self.userFollowingCountLabel.userInteractionEnabled = true
        self.userFollowingCountLabel.addGestureRecognizer(followingTap)
    }
    
    //tapped followers count
    func followersTap() {
        user = visitorName.last!
        show = "followers"
        
        let followers = self.storyboard?.instantiateViewControllerWithIdentifier("FollowersTableViewController") as! FollowersTableViewController
        self.navigationController? .pushViewController(followers, animated: true)
        
    }
    
    //tapped followeing count
    func followingTap() {
        user = visitorName.last!
        show = "following"
        
        let following = self.storyboard?.instantiateViewControllerWithIdentifier("FollowersTableViewController") as! FollowersTableViewController
        self.navigationController? .pushViewController(following, animated: true)
    }
    
    @IBAction func followButtonTapped(sender: AnyObject) {
        
        let title = userFollowButton.titleForState(.Normal)
        
        //follow user
        if(title == "FOLLOW") {
            let object = PFObject(className: "Followers")
            object["follower"] = PFUser.currentUser()?.username
            object["following"] = visitorName.last!
            
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                if(success) {
                    self.userFollowButton.setTitle("Following", forState: UIControlState.Normal)
                    self.userFollowButton.backgroundColor = .greenColor()
                } else {
                    print(error?.localizedDescription)
                }
            })
            
            
        } else {
            let query = PFQuery(className: "Followers")
            query.whereKey("follower", equalTo: (PFUser.currentUser()?.username)!)
            query.whereKey("following", equalTo: visitorName.last!)
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                            if (success) {
                                self.userFollowButton.setTitle("Follow +", forState: UIControlState.Normal)
                                self.userFollowButton.backgroundColor = .lightGrayColor()
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
    
    func loadProfilePictureDimensions(){
        self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2;
        self.profilePictureImageView.clipsToBounds = true;
    }

}
