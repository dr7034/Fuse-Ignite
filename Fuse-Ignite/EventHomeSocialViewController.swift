//
//  EventHomeSocialViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 07/03/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class EventHomeViewController: UIViewController {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationNameLabel: UILabel!
    @IBOutlet weak var eventLocationAddress1: UILabel!
    @IBOutlet weak var eventLocationPostcodeLabel: UILabel!
    @IBOutlet weak var eventLocationCountry: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var userProfilePicture: UIImageView!
    
    var window: UIWindow?
    var drawerContainer: MMDrawerController?
    
    // Container to store the view table selected object
    var currentObject : PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Unwrap the current object object
        if let object = currentObject {
            eventNameLabel.text = object["eventName"] as? String
            eventLocationNameLabel.text = object["eventLocationName"] as? String
            eventLocationAddress1.text = object["eventAddress1"] as? String
            eventLocationPostcodeLabel.text = object["eventPostcode"] as? String
            eventLocationCountry.text = object["eventCountry"] as? String
            eventDescriptionLabel.text = object["eventDescription"] as? String
            
            
        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
        
        loadProfilePicture()
    }
    
    @IBAction func leftSideButtonTapped(sender: AnyObject) {
        drawerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }
    
    @IBAction func rightSideButtonTapped(sender: AnyObject) {
        
        
        drawerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
    }
    
    func loadProfilePicture(){
        
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

    
}