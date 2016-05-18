//
//  ProfileViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 16/02/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import ParseUI



class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userJobTitleLabel: UILabel!
    @IBOutlet weak var userCompanyLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userBioTextView: UITextView!
    @IBOutlet weak var userNetworkingObjectivesTextView: UITextView!
    @IBOutlet weak var userFollowingCountLabel: UILabel!
    @IBOutlet weak var userFollowersCountLabel: UILabel!
    @IBOutlet weak var userScheduledEventsCountLabel: UILabel!
    
    //tableview outlets
    @IBOutlet weak var conversationTopicsTableView: UITableView!
    @IBOutlet weak var eventObjectivesTableView: UITableView!
    @IBOutlet weak var motivationsTableView: UITableView!
    
    // Container to store the view table selected object
    var currentObject : PFObject?
    
    /// A simple data structure to populate the table view.
    struct PreviewDetail {
        let title: String
        let preferredHeight: Double
    }
    
    let conversationTopics =  [
    
        PreviewDetail(title: "Nine", preferredHeight: 160.0),
        PreviewDetail(title: "Ten", preferredHeight: 320.0),
        PreviewDetail(title: "Eleven", preferredHeight: 0.0), // 0.0 to get the default height.
        PreviewDetail(title: "More", preferredHeight: 0.0) // 0.0 to get the default height.
        
    ]
    
    let eventObjectives = [
        PreviewDetail(title: "Nine", preferredHeight: 160.0),
        PreviewDetail(title: "Ten", preferredHeight: 320.0),
        PreviewDetail(title: "Eleven", preferredHeight: 0.0), // 0.0 to get the default height.
        PreviewDetail(title: "More", preferredHeight: 0.0) // 0.0 to get the default height.
    ]
    
    let motivations = [
        PreviewDetail(title: "Nine", preferredHeight: 160.0),
        PreviewDetail(title: "Ten", preferredHeight: 320.0),
        PreviewDetail(title: "Eleven", preferredHeight: 0.0), // 0.0 to get the default height.
        PreviewDetail(title: "More", preferredHeight: 0.0) // 0.0 to get the default height.
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserData()
        loadProfilePicture()
        
        conversationTopicsTableView.dataSource = self
        conversationTopicsTableView.delegate = self
        conversationTopicsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "conversationTopicsCell")
        
        eventObjectivesTableView.dataSource = self
        eventObjectivesTableView.delegate = self
        eventObjectivesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "eventObjectivesCell")
        
        motivationsTableView.dataSource = self
        motivationsTableView.delegate = self
        motivationsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "motivationsCell")
        
        
        }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in the sample data structure.
        
        var count:Int?
        
        if tableView == self.conversationTopicsTableView {
            count = conversationTopics.count
        }
        
        if tableView == self.eventObjectivesTableView {
            count =  eventObjectives.count
        }
        
        if tableView == self.motivationsTableView {
            count =  motivations.count
        }
        
        return count!
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
        if tableView == self.conversationTopicsTableView {
            cell = tableView.dequeueReusableCellWithIdentifier("conversationTopicsCell", forIndexPath: indexPath)
            let previewDetail = conversationTopics[indexPath.row]
            cell!.textLabel!.text = previewDetail.title
            
        }
        
        if tableView == self.eventObjectivesTableView {
            cell = tableView.dequeueReusableCellWithIdentifier("eventObjectivesCell", forIndexPath: indexPath)
            let previewDetail = eventObjectives[indexPath.row]
            cell!.textLabel!.text = previewDetail.title
            
        }
        
        if tableView == self.motivationsTableView {
            cell = tableView.dequeueReusableCellWithIdentifier("motivationsCell", forIndexPath: indexPath)
            let previewDetail = motivations[indexPath.row]
            cell!.textLabel!.text = previewDetail.title
            
        }
        
        return cell!
    }
    
    func getUserData(){
        
        PFUser.currentUser()!.fetchInBackgroundWithBlock({ (currentUser: PFObject?, error: NSError?) -> Void in
            
            // Update your data
            
            if let user = currentUser as? PFUser {
                
                let userBio = PFUser.currentUser()?.objectForKey("userBio") as! String
                let userFullName = PFUser.currentUser()?.objectForKey("fullName") as! String
                let userJobTitle = PFUser.currentUser()?.objectForKey("jobTitle") as! String
                let userCompanyName = PFUser.currentUser()?.objectForKey("companyName") as! String
                let userNetworkingObjectives = PFUser.currentUser()?.objectForKey("networkingObjectives") as! String

                self.userBioTextView.text = userBio
                self.userFullNameLabel.text = userFullName
                self.userJobTitleLabel.text = userJobTitle
                self.userCompanyLabel.text = userCompanyName
                self.userNetworkingObjectivesTextView.text = userNetworkingObjectives
                
            
                let followers = PFQuery(className: "Followers")
                followers.whereKey("following", equalTo: user.username!)
                followers.countObjectsInBackgroundWithBlock({ (count: Int32, error: NSError?) in
                    self.userFollowersCountLabel.text = "\(count)"
                })
                
                let followersTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.followersTap))
                followersTap.numberOfTapsRequired = 1
                self.userFollowersCountLabel.userInteractionEnabled = true
                self.userFollowersCountLabel.addGestureRecognizer(followersTap)
                
                let following = PFQuery(className: "Followers")
                following.whereKey("follower", equalTo: user.username!)
                following.countObjectsInBackgroundWithBlock({ (count: Int32, error: NSError?) in
                    self.userFollowingCountLabel.text = "\(count)"
                })
                
                let followingTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.followingTap))
                followingTap.numberOfTapsRequired = 1
                self.userFollowingCountLabel.userInteractionEnabled = true
                self.userFollowingCountLabel.addGestureRecognizer(followingTap)
            }
        })
    }
    
    func followersTap() {
        user = (PFUser.currentUser()?.username)!
        show = "followers"
        
        let followers = self.storyboard?.instantiateViewControllerWithIdentifier("FollowersTableViewController") as! FollowersTableViewController
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    func followingTap() {
        user = (PFUser.currentUser()?.username)!
        show = "following"
        
        let following = self.storyboard?.instantiateViewControllerWithIdentifier("FollowersTableViewController") as! FollowersTableViewController
        self.navigationController?.pushViewController(following, animated: true)
    }

    
    @IBAction func leftSideButtonTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }
    
    @IBAction func rightSideButtonTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
    }
    
    @IBAction func editProfileButtonTapped(sender: AnyObject) {
        
        
    }
    
    func loadProfilePicture(){
        
        let profilePictureObject = PFUser.currentUser()?.objectForKey("profile_picture") as! PFFile
        
        profilePictureObject.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            
            if(imageData != nil)
            {
                self.profilePictureImageView.image = UIImage(data: imageData!)
            }
        }
        self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2;
        self.profilePictureImageView.clipsToBounds = true;
    }
    
    
    

}
