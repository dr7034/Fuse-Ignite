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
    
    //This is not the right way to go about this. It's awful. A stack or table view needs to be implemented for all of these sections such as in the event home
    
    //Talk to me about
    @IBOutlet weak var userSubject0: UILabel!
    @IBOutlet weak var userSubject1: UILabel!
    @IBOutlet weak var userSubject2: UILabel!
    @IBOutlet weak var userSubject3: UILabel!
    @IBOutlet weak var userSubject4: UILabel!
    @IBOutlet weak var userSubject5: UILabel!
    @IBOutlet weak var userSubject6: UILabel!
    @IBOutlet weak var userSubject7: UILabel!
    
    
    //Phrases Around Me
    @IBOutlet weak var userPhraseAround0: UILabel!
    @IBOutlet weak var userPhraseAround1: UILabel!
    @IBOutlet weak var userPhraseAround2: UILabel!
    @IBOutlet weak var userPhraseAround3: UILabel!
    
    //What Motivates Me
    @IBOutlet weak var userMotivateMe0: UILabel!
    @IBOutlet weak var userMotivateMe1: UILabel!
    @IBOutlet weak var userMotivateMe2: UILabel!
    @IBOutlet weak var userMotivateMe3: UILabel!
    
    
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
