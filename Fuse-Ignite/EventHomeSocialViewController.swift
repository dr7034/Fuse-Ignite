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
//import TwitterKit

class EventHomeViewController: UIViewController
{

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationNameLabel: UILabel!
    @IBOutlet weak var eventLocationAddress1: UILabel!
    @IBOutlet weak var eventLocationPostcodeLabel: UILabel!
    @IBOutlet weak var eventLocationCountry: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var userProfilePicture: UIImageView!
    
    @IBOutlet weak var relevantUsersTableView: UITableView!
    @IBOutlet weak var noTopicsInCommonTableView: UITableView!
    
    
    var window: UIWindow?
    var drawerContainer: MMDrawerController?
    
    // Container to store the view table selected object
    var currentObject : PFObject?
    
//    let numberOfRowsInRelevantUsersTableView = 3
//    let numberOfRowsInNoTopicsInCommonTableView = 4
    
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
        
//        self.relevantUsersTableView.delegate = self
//        self.relevantUsersTableView.dataSource = self
//        self.noTopicsInCommonTableView.delegate = self
//        self.noTopicsInCommonTableView.delegate = self
        
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
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (tableView == self.relevantUsersTableView) ? self.numberOfRowsInRelevantUsersTableView : self.numberOfRowsInNoTopicsInCommonTableView
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if(tableView == self.relevantUsersTableView){
//            let cell: RelevantUsersCell = tableView.dequeueReusableCellWithIdentifier("relevantUsersCell") as! RelevantUsersCell
//            cell.userNameRULabel.text = "Relevant Users row: \(indexPath.row)"
//            return cell
//        }else{
//            let cell: NoTopicsInCommonCell = tableView.dequeueReusableCellWithIdentifier("noTopicsInCommonCell") as! NoTopicsInCommonCell
//            cell.userNameNTLabel.text  = "No Topics row: \(indexPath.row)"
//            return cell
//        }
//    }
    
}