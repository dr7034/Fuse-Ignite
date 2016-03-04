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

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userJobTitleLabel: UILabel!
    @IBOutlet weak var userCompanyLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadUserDetails()

            if(PFUser.currentUser()?.objectForKey("profile_picture") != nil)
            {
                let userImageFile:PFFile = PFUser.currentUser()?.objectForKey("profile_picture") as! PFFile
                
                userImageFile.getDataInBackgroundWithBlock({ (imageData:NSData?, error:NSError?) -> Void in
                    
                    if(imageData != nil)
                    {
                        self.profilePictureImageView.image = UIImage(data: imageData!)
                        self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2;
                        self.profilePictureImageView.clipsToBounds = true;
                    }
                })
            }
        }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        profilePictureImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func leftSideButtonTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }
    
    @IBAction func rightSideButtonTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
    }
    
    func loadUserDetails()
    {
//        // Load User Details
//        let userFullName = PFUser.currentUser()?.objectForKey("fullName") as! String
//        let userCompanyName = PFUser.currentUser()?.objectForKey("companyName") as! String
//        let userJobTitle = PFUser.currentUser()?.objectForKey("jobTitle") as! String
//        
//        userFullNameLabel.text = userFullName
//        userCompanyLabel.text = userCompanyName
//        userJobTitleLabel.text = userJobTitle
//        
    }


}
