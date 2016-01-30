//
//  MainPageViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 15/01/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse

class MainPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var eventFeedTable: UITableView!
    @IBOutlet weak var currentDateTime: UILabel!
    @IBOutlet weak var userProfilePicture: UIImageView!
    
    
    var users = [PFUser]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Clears Badges on Page open
            let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.badge = 0
        
            loadUsers()
            loadUserDetails()
            currentDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftSideButtonTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)

    }

    @IBAction func rightSideButtonTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCellWithIdentifier("eventFeedTableViewCell0", forIndexPath: indexPath)
        
        let userObject: PFUser = users[indexPath.row]
        
        userCell.textLabel!.text = userObject.objectForKey("first_name") as? String
        
        return userCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let selectedUser: PFUser = users[indexPath.row]
        
        let eventFeedTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EventFeedTableViewController") as! EventFeedTableViewController
        
        eventFeedTableViewController.selectedUser = selectedUser
        
        self.navigationController?.pushViewController(eventFeedTableViewController, animated: true)
        
        
    }
    
    func loadUsers()
    {
        let userQuery = PFQuery(className: "_User")
        userQuery.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) -> Void in
            
            if let foundUsers = result as? [PFUser]
            {
                self.users = foundUsers
                self.eventFeedTable.reloadData()
            }
            
            
        }
    }
    
    func loadUserDetails(){
        
        let profilePictureObject = PFUser.currentUser()?.objectForKey("profile_picture") as! PFFile
        
        profilePictureObject.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            
            if(imageData != nil)
            {
                self.userProfilePicture.image = UIImage(data: imageData!)
            }
        }
        self.userProfilePicture.layer.cornerRadius = self.userProfilePicture.frame.size.width / 2;
        self.userProfilePicture.clipsToBounds = true;
    }
    
    func currentDate(){
        
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        self.currentDateTime.text = convertedDate
        
        
    }
    
    
}
