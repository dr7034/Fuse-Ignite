//
//  EventHomeSocialTableViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 20/04/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class EventHomeSocialTableViewController: PFQueryTableViewController {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationNameLabel: UILabel!
    @IBOutlet weak var eventLocationAddress1Label: UILabel!
    @IBOutlet weak var eventLocationPostcodeLabel: UILabel!
    @IBOutlet weak var eventLocationCountryLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var userProfilePictureImage: UIImageView!
    
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
            eventLocationAddress1Label.text = object["eventAddress1"] as? String
            eventLocationPostcodeLabel.text = object["eventPostcode"] as? String
            eventLocationCountryLabel.text = object["eventCountry"] as? String
            eventDescriptionLabel.text = object["eventDescription"] as? String
            
            
        }

        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
        
        loadProfilePicture()
    }
    
    //Init the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        //Configure the PFQueryTableView
        self.parseClassName = "_User"
        self.textKey = "eventName"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "_User")
        query.orderByAscending("userInterests")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("RelevantUsersCell") as? PFTableViewCell!
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "RelevantUsersCell") as! PFTableViewCell
        }
    // Extract values from the PFObject to display in the table cell
        if let relevantUsers = object? ["fullName"] as? String {
            cell?.textLabel?.text = relevantUsers
        }
        
        if let userInterests = object?["userInterests"] as? NSArray {
            cell?.detailTextLabel?.text = userInterests.componentsJoinedByString(" , #")
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showProfile", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nav = segue.destinationViewController as! UINavigationController
        let profileViewController = nav.topViewController as! ProfileViewController
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let row = Int(indexPath.row)
            profileViewController.currentObject = (objects?[row]) as? PFObject
        }
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
                self.userProfilePictureImage.image = UIImage(data: imageData!)
            }
        }
        self.userProfilePictureImage.layer.cornerRadius = self.userProfilePictureImage.frame.size.width / 2;
        self.userProfilePictureImage.clipsToBounds = true;
    }
    
}