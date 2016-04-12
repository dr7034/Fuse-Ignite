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
    @IBOutlet weak var userBioTextView: UITextView!
    @IBOutlet weak var userNetworkingObjectivesTextView: UITextView!
    
    // Container to store the view table selected object
    var currentObject : PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProfilePicture()
        if let user = currentObject {
        userFullNameLabel.text = user["fullName"] as? String
        }
        
            userFullNameLabel.text = "Daniel Reilly"
            userJobTitleLabel.text = "Founder"
            userCompanyLabel.text = "Fuse Technology"

        
        }
    
    @IBAction func leftSideButtonTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }
    
    @IBAction func rightSideButtonTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
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
