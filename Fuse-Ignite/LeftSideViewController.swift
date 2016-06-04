//
//  LeftSideViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 15/01/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse

class LeftSideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    
    
    var menuItems:[String] = ["Home","Discover","Create an Event","My Events","Contacts","Profile","Beacon Testing Ground","Sign Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserDetails()
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let myCell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) 
        
        myCell.textLabel?.text = menuItems[indexPath.row]
        
        return myCell
    }
    
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
            
            switch(indexPath.row)
            {
            case 0:
            //open main Page
               
                let eventFeedTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EventFeedTableViewController") as! EventFeedTableViewController
                
                let eventFeedPageNav = UINavigationController(rootViewController: eventFeedTableViewController)
                
                //access AppDelegate to access drawerContainer function
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = eventFeedPageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
                
            case 1:
            
            //open discover page
                let discoverTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DiscoverTableViewController") as! DiscoverTableViewController
                
                let discoverPageNav = UINavigationController(rootViewController: discoverTableViewController)
                
                //access AppDelegate to access drawerContainer function
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = discoverPageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                
                
            break
                
            case 2:
                
                //open create an event page
                let createViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CreateViewController") as! CreateViewController
                
                let createPageNav = UINavigationController(rootViewController: createViewController)
                
                //access AppDelegate to access drawerContainer function
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = createPageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
                
            case 3:
                
                //open my events page
                let myEventsTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyEventsTableViewController") as! MyEventsTableViewController
                
                let myEventsPageNav = UINavigationController(rootViewController: myEventsTableViewController)
                
                //access AppDelegate to access drawerContainer function
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = myEventsPageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                
                break
                
            case 4:
                
                //open contacts page
                let contactsTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContactsTableViewController") as! ContactsTableViewController
                
                let contactsPageNav = UINavigationController(rootViewController: contactsTableViewController)
                
                //access AppDelegate to access drawerContainer function
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = contactsPageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                
                break
                
            case 5:
                
                //open profile page
                let profileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
                
                let profilePageNav = UINavigationController(rootViewController: profileViewController)
                
                //access AppDelegate to access drawerContainer function
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = profilePageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                
                break
                
            case 6:
                
                //open profile page
                let beaconTestViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BeaconTestViewController") as! BeaconTestViewController
                
                let beaconTestPageNav = UINavigationController(rootViewController: beaconTestViewController)
                
                //access AppDelegate to access drawerContainer function
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = beaconTestPageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                
                break
                
            case 7:
            
            //perform sign out and take user to sign in page
                
                NSUserDefaults.standardUserDefaults().removeObjectForKey("user_name")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                //Perform Sign Out
                PFUser.logOutInBackgroundWithBlock({ (error:NSError?) -> Void in
                    
                    //Navigate to protected Page
                    
                    let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let signInPage:ViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                    
                    let signInPageNav = UINavigationController(rootViewController:signInPage)
                    
                    //access AppDelegate to access signInPageNav
                    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.window?.rootViewController = signInPageNav
                })
                
            break
                
            default:
                print("Option is not handled.")
            }
            
    }
    
    @IBAction func editProfileButtonTapped(sender: AnyObject) {
        
        let editProfile = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController
        editProfile.opener = self
        
        let editProfileNav = UINavigationController(rootViewController: editProfile)
        
        self.presentViewController(editProfileNav, animated: true, completion: nil)
    }
    
    func loadUserDetails(){
        
        let userFullName = PFUser.currentUser()?.objectForKey("fullName") as! String
        
        userFullNameLabel.text = userFullName
        
        let profilePictureObject = PFUser.currentUser()?.objectForKey("profile_picture") as! PFFile
        
        profilePictureObject.getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
            if(imageData != nil)
            {
                self.userProfilePicture.image = UIImage(data: imageData!)
            }
        }
        self.userProfilePicture.layer.cornerRadius = self.userProfilePicture.frame.size.width / 2;
        self.userProfilePicture.clipsToBounds = true;
    }
}
