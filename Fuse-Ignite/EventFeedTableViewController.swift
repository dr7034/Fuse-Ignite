//
//  EventFeedTableViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 03/03/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class EventFeedTableViewController: PFQueryTableViewController {
    
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var currentDateTime: UILabel!
    
    var usernameArray = [String]()
    var avatarArray = [PFFile]()
    var imageArray = [PFFile]()
    var dateArray = [NSDate?]()
    var titleArray = [String]()
    var uuidArray = [String]()
    
    var followArray = [String]()
    
    var page: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Clears Badges on Page open
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.badge = 0
        
        loadProfilePicture()
        currentDate()
    }
    
    
    

    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "UpdateObject"
        self.textKey = "objectId"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "UpdateObject")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("discoverCell") as! PFTableViewCell!
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "discoverCell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let eventName = object?["eventName"] as? String {
            cell?.textLabel?.text = eventName
        }
        if let eventDescription = object?["eventDescription"] as? String {
            cell?.detailTextLabel?.text = eventDescription
        }
        
        return cell
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
