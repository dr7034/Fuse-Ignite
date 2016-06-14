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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) 
        
        myCell.textLabel?.text = menuItems[(indexPath as NSIndexPath).row]
        
        return myCell
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
            
            switch((indexPath as NSIndexPath).row)
            {
            case 0:
            //open main Page
               
                let eventFeedTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "EventFeedTableViewController") as! EventFeedTableViewController
                
                let eventFeedPageNav = UINavigationController(rootViewController: eventFeedTableViewController)
                
                //access AppDelegate to access drawerContainer function
                let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = eventFeedPageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            
            break
                
            case 1:
            
            //open discover page
                let discoverTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverTableViewController") as! DiscoverTableViewController
                
                let discoverPageNav = UINavigationController(rootViewController: discoverTableViewController)
                
                //access AppDelegate to access drawerContainer function
                let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = discoverPageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
                
                
            break
                
            case 2:
                
                //open create an event page
                let createViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateViewController") as! CreateViewController
                
                let createPageNav = UINavigationController(rootViewController: createViewController)
                
                //access AppDelegate to access drawerContainer function
                let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = createPageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            
            break
                
            case 3:
                
                //open my events page
                let myEventsTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyEventsTableViewController") as! MyEventsTableViewController
                
                let myEventsPageNav = UINavigationController(rootViewController: myEventsTableViewController)
                
                //access AppDelegate to access drawerContainer function
                let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = myEventsPageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
                
                break
                
            case 4:
                
                //open contacts page
                let contactsTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContactsTableViewController") as! ContactsTableViewController
                
                let contactsPageNav = UINavigationController(rootViewController: contactsTableViewController)
                
                //access AppDelegate to access drawerContainer function
                let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = contactsPageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
                
                break
                
            case 5:
                
                //open profile page
                let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                
                let profilePageNav = UINavigationController(rootViewController: profileViewController)
                
                //access AppDelegate to access drawerContainer function
                let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = profilePageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
                
                break
                
            case 6:
                
                //open profile page
                let beaconTestViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeaconTestViewController") as! BeaconTestViewController
                
                let beaconTestPageNav = UINavigationController(rootViewController: beaconTestViewController)
                
                //access AppDelegate to access drawerContainer function
                let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = beaconTestPageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
                
                break
                
            case 7:
            
            //perform sign out and take user to sign in page
                
                UserDefaults.standard().removeObject(forKey: "user_name")
                UserDefaults.standard().synchronize()
                
                //Perform Sign Out
                PFUser.logOutInBackground({ (error:NSError?) -> Void in
                    
                    //Navigate to protected Page
                    
                    let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let signInPage:ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    
                    let signInPageNav = UINavigationController(rootViewController:signInPage)
                    
                    //access AppDelegate to access signInPageNav
                    let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
                    
                    appDelegate.window?.rootViewController = signInPageNav
                })
                
            break
                
            default:
                print("Option is not handled.")
            }
            
    }
    
    @IBAction func editProfileButtonTapped(_ sender: AnyObject) {
        
        let editProfile = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        editProfile.opener = self
        
        let editProfileNav = UINavigationController(rootViewController: editProfile)
        
        self.present(editProfileNav, animated: true, completion: nil)
    }
    
    func loadUserDetails(){
        
        let userFullName = PFUser.current()?.object(forKey: "fullName") as! String
        
        userFullNameLabel.text = userFullName
        
        let profilePictureObject = PFUser.current()?.object(forKey: "profile_picture") as! PFFile
        
        profilePictureObject.getDataInBackground { (imageData: Data?, error:NSError?) -> Void in
            if(imageData != nil)
            {
                self.userProfilePicture.image = UIImage(data: imageData!)
            }
        }
        self.userProfilePicture.layer.cornerRadius = self.userProfilePicture.frame.size.width / 2;
        self.userProfilePicture.clipsToBounds = true;
    }
}
