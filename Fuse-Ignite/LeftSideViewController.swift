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
    
    
    var menuItems:[String] = ["Main","About","Sign Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadUserDetails()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var myCell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! UITableViewCell
        
        myCell.textLabel?.text = menuItems[indexPath.row]
        
        return myCell
    }
    
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
            
            switch(indexPath.row)
            {
            case 0:
            //open main Page
               
                var mainPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
                
                var mainPageNav = UINavigationController(rootViewController: mainPageViewController)
                
                //access AppDelegate to access drawerContainer function
                var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = mainPageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
                
            case 1:
            
            //open about page
                var aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
                
                var aboutPageNav = UINavigationController(rootViewController: aboutViewController)
                
                //access AppDelegate to access drawerContainer function
                var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                //use drawerContainer class to access main page
                appDelegate.drawerContainer!.centerViewController = aboutPageNav
                
                //Close drawer on open
                appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
                
                
            break
                
            case 2:
            
            //perform sign out and take user to sign in page
                
                NSUserDefaults.standardUserDefaults().removeObjectForKey("user_name")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                //Perform Sign Out
                PFUser.logOutInBackgroundWithBlock({ (error:NSError?) -> Void in
                    
                    //Navigate to protected Page
                    
                    let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    var signInPage:ViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                    
                    var signInPageNav = UINavigationController(rootViewController:signInPage)
                    
                    //access AppDelegate to access signInPageNav
                    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.window?.rootViewController = signInPageNav
                })
                
            break
                
            default:
                print("Option is not handled.")
            }
            
    }
    
    @IBAction func editProfileButtonTapped(sender: AnyObject) {
        
        var editProfile = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController
        editProfile.opener = self
        
        let editProfileNav = UINavigationController(rootViewController: editProfile)
        
        self.presentViewController(editProfileNav, animated: true, completion: nil)
    }
    
    func loadUserDetails(){
        
        let userFirstName = PFUser.currentUser()?.objectForKey("first_name") as! String
        let userLastName = PFUser.currentUser()?.objectForKey("last_name") as! String
        
        userFullNameLabel.text = userFirstName + " " + userLastName
        
        let profilePictureObject = PFUser.currentUser()?.objectForKey("profile_picture") as! PFFile
        
        profilePictureObject.getDataInBackgroundWithBlock { (imageData: NSData?, error:NSError?) -> Void in
            if(imageData != nil)
            {
                self.userProfilePicture.image = UIImage(data: imageData!)
            }
        }
    }
}
