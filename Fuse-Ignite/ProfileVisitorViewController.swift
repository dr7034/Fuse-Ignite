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

class ProfileVisitorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    
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
    
    
    @IBOutlet weak var userEmailAddressLabel: UILabel!
    @IBOutlet weak var userTelephoneNumberLabel: UILabel!
    @IBOutlet weak var userWebPageLabel: UILabel!
    
    //table views
    @IBOutlet weak var conversationTopicsTableView: UITableView!
    @IBOutlet weak var eventObjectivesTableView: UITableView!
    @IBOutlet weak var motivationsTableView: UITableView!
    @IBOutlet weak var interestsTableView: UITableView!
    
    //Table Views Arrays to store data pulled from parse to display
    var conversationTopics: [String] = []
    var eventObjectives: [String] = []
    var motivations: [String] = []
    var interests: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        setTableViewDelegates()
    }
    
    

        
    func getUserData() {
        
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
//                    self.conversationTopics = object.valueForKey("conversationTopics") as! [String]
//                    self.eventObjectives = object.valueForKey("eventObjectives") as! [String]
//                    self.motivations = object.valueForKey("userMotivations") as! [String]
//                    self.interests = object.valueForKey("userInterests") as! [String]
                    let profilePicFile: PFFile = (object.objectForKey("profile_picture") as? PFFile)!
                    
                    //These need to show for only mutual followers
                    self.userTelephoneNumberLabel.text = object["telNumber"] as? String
                    self.userEmailAddressLabel.text = object["email"] as? String
                    self.userWebPageLabel.text = object["webPage"] as? String
                    
//                    self.conversationTopicsTableView.reloadData()
//                    self.eventObjectivesTableView.reloadData()
//                    self.motivationsTableView.reloadData()
//                    self.interestsTableView.reloadData()
                    
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
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(ProfileVisitorViewController.followersTap))
        followersTap.numberOfTapsRequired = 1
        self.userFollowersCountLabel.userInteractionEnabled = true
        self.userFollowersCountLabel.addGestureRecognizer(followersTap)
        
        //tap to get users following
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(ProfileVisitorViewController.followingTap))
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
    
    func setTableViewDelegates() {
        conversationTopicsTableView.dataSource = self
        conversationTopicsTableView.delegate = self
        
        eventObjectivesTableView.dataSource = self
        eventObjectivesTableView.delegate = self
        
        motivationsTableView.dataSource = self
        motivationsTableView.delegate = self
        
        interestsTableView.dataSource = self
        interestsTableView.delegate = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in the sample data structure.
        var count:Int?
        
        if tableView == self.conversationTopicsTableView {
            count = self.conversationTopics.count
        }
        if tableView == self.eventObjectivesTableView {
            count =  self.eventObjectives.count
        }
        if tableView == self.motivationsTableView {
            count =  self.motivations.count
        }
        if tableView == self.interestsTableView {
            count =  self.interests.count
        }
        return count!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if tableView == self.conversationTopicsTableView {
            cell = tableView.dequeueReusableCellWithIdentifier("conversationTopicsCell", forIndexPath: indexPath)
            cell.textLabel?.text = self.conversationTopics[indexPath.row]
        }
        
        if tableView == self.eventObjectivesTableView {
            cell = tableView.dequeueReusableCellWithIdentifier("eventObjectivesCell", forIndexPath: indexPath)
            cell.textLabel?.text = self.eventObjectives[indexPath.row]
        }
        
        if tableView == self.motivationsTableView {
            cell = tableView.dequeueReusableCellWithIdentifier("motivationsCell", forIndexPath: indexPath)
            cell.textLabel?.text = self.motivations[indexPath.row]
        }
        if tableView == self.interestsTableView {
            cell = tableView.dequeueReusableCellWithIdentifier("interestsCell", forIndexPath: indexPath)
            cell.textLabel?.text = self.interests[indexPath.row]
        }
        return cell
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
