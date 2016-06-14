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
    
    @IBOutlet weak var userEmailAddressLabel: UILabel!
    @IBOutlet weak var userTelephoneNumberLabel: UILabel!
    @IBOutlet weak var userWebPageLabel: UILabel!
    
    //tableview outlets
    @IBOutlet weak var conversationTopicsTableView: UITableView!
    @IBOutlet weak var eventObjectivesTableView: UITableView!
    @IBOutlet weak var motivationsTableView: UITableView!
    @IBOutlet weak var interestsTableView: UITableView!
    
    // Container to store the view table selected object
    var currentObject : PFObject?

    //Table Views Arrays to store data pulled from parse to display
    var conversationTopics: [String] = []
    var eventObjectives: [String] = []
    var motivations: [String] = []
    var interests: [String] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        loadProfilePicture()
        getTableViewDataFromParse()
        setTableViewDelegates()
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

    func getTableViewDataFromParse() {
        PFUser.current()!.fetchInBackground { (object: PFObject?, error: NSError?) in
            
            let conversationTopicsData = object!.value(forKey: "conversationTopics")
            let eventObjectivesData = object!.value(forKey: "eventObjectives")
            let motivationsData = object!.value(forKey: "userMotivations")
            let interestsData = object!.value(forKey: "userInterests")
            
            self.conversationTopics = conversationTopicsData! as! [String]
            self.eventObjectives = eventObjectivesData! as! [String]
            self.motivations = motivationsData! as! [String]
            self.interests = interestsData! as! [String]
            
            self.conversationTopicsTableView.reloadData()
            self.eventObjectivesTableView.reloadData()
            self.motivationsTableView.reloadData()
            self.interestsTableView.reloadData()

            }
    
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if tableView == self.conversationTopicsTableView {
        cell = tableView.dequeueReusableCell(withIdentifier: "conversationTopicsCell", for: indexPath)
        cell.textLabel?.text = self.conversationTopics[(indexPath as NSIndexPath).row]
        }
        
        if tableView == self.eventObjectivesTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "eventObjectivesCell", for: indexPath)
            cell.textLabel?.text = self.eventObjectives[(indexPath as NSIndexPath).row]
        }
        
        if tableView == self.motivationsTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "motivationsCell", for: indexPath)
            cell.textLabel?.text = self.motivations[(indexPath as NSIndexPath).row]
        }
        if tableView == self.interestsTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "interestsCell", for: indexPath)
            cell.textLabel?.text = self.interests[(indexPath as NSIndexPath).row]
        }
        return cell
    }
    
    func getUserData(){
        
        PFUser.current()!.fetchInBackground({ (currentUser: PFObject?, error: NSError?) -> Void in
            
            // Update your data
            
            if let user = currentUser as? PFUser {
                
                let userBio = PFUser.current()?.object(forKey: "userBio") as! String
                let userFullName = PFUser.current()?.object(forKey: "fullName") as! String
                let userJobTitle = PFUser.current()?.object(forKey: "jobTitle") as! String
                let userCompanyName = PFUser.current()?.object(forKey: "companyName") as! String
                let userNetworkingObjectives = PFUser.current()?.object(forKey: "networkingObjectives") as! String
                let userEmailAddress = PFUser.current()?.object(forKey: "email") as! String
                let userWebPage = PFUser.current()?.object(forKey: "webPage") as! String
                let userTelNumber = PFUser.current()?.object(forKey: "telNumber") as! String
                
                self.userBioTextView.text = userBio
                self.userFullNameLabel.text = userFullName
                self.userJobTitleLabel.text = userJobTitle
                self.userCompanyLabel.text = userCompanyName
                self.userNetworkingObjectivesTextView.text = userNetworkingObjectives
                self.userEmailAddressLabel.text = userEmailAddress
                self.userWebPageLabel.text = userWebPage
                self.userTelephoneNumberLabel.text = userTelNumber
                
                let followers = PFQuery(className: "Followers")
                followers.whereKey("following", equalTo: user.username!)
                followers.countObjectsInBackground({ (count: Int32, error: NSError?) in
                    self.userFollowersCountLabel.text = "\(count)"
                })
                
                let followersTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.followersTap))
                followersTap.numberOfTapsRequired = 1
                self.userFollowersCountLabel.isUserInteractionEnabled = true
                self.userFollowersCountLabel.addGestureRecognizer(followersTap)
                
                let following = PFQuery(className: "Followers")
                following.whereKey("follower", equalTo: user.username!)
                following.countObjectsInBackground({ (count: Int32, error: NSError?) in
                    self.userFollowingCountLabel.text = "\(count)"
                })
                
                let followingTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.followingTap))
                followingTap.numberOfTapsRequired = 1
                self.userFollowingCountLabel.isUserInteractionEnabled = true
                self.userFollowingCountLabel.addGestureRecognizer(followingTap)
            }
        })
    }
    
    func followersTap() {
        user = (PFUser.current()?.username)!
        show = "followers"
        
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersTableViewController") as! FollowersTableViewController
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    func followingTap() {
        user = (PFUser.current()?.username)!
        show = "following"
        
        let following = self.storyboard?.instantiateViewController(withIdentifier: "FollowersTableViewController") as! FollowersTableViewController
        self.navigationController?.pushViewController(following, animated: true)
    }

    
    @IBAction func leftSideButtonTapped(_ sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    @IBAction func rightSideButtonTapped(_ sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggle(MMDrawerSide.right, animated: true, completion: nil)
    }
    
    @IBAction func editProfileButtonTapped(_ sender: AnyObject) {
        
    }
    
    func loadProfilePicture(){
        
        let profilePictureObject = PFUser.current()?.object(forKey: "profile_picture") as! PFFile
        
        profilePictureObject.getDataInBackground { (imageData: Data?, error: NSError?) -> Void in
            
            if(imageData != nil)
            {
            self.profilePictureImageView.image = UIImage(data: imageData!)
            }
        }
        self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2;
        self.profilePictureImageView.clipsToBounds = true;
    }
}
