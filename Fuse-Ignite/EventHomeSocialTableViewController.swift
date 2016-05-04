//
//  EventHomeSocialTableViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 20/04/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import CoreBluetooth
import ParseUI

class RelevantUsersCustomCell: PFTableViewCell
{
    @IBOutlet var userFullName: UILabel!
    @IBOutlet var userInterests: UILabel!
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userDistance: UILabel!
}



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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> RelevantUsersCustomCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("RelevantUsersCell") as? RelevantUsersCustomCell!
        if cell == nil {
            cell = RelevantUsersCustomCell(style: UITableViewCellStyle.Default, reuseIdentifier: "RelevantUsersCell")
        }
    // Extract values from the PFObject to display in the table cell
        
        if let relevantUsers = object?["fullName"] as? String {
            cell?.userFullName?.text = relevantUsers
        }
        
        if let userInterests = object?["userInterests"] as? NSArray {
            cell?.userInterests?.text = userInterests.componentsJoinedByString(", ")
            
        }
            
//        let userProfilePicture = object?["profile_picture"] as? PFFile
//        userProfilePicture!.getDataInBackgroundWithBlock {
//            (imageData: NSData?, error: NSError?) -> Void in
//            if error == nil {
//                if let imageData = imageData {
//                    let image = UIImage(data:imageData)
//                }
//            }
//        }
        
        return cell!
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let header1: String = "Relevant Users"

        return header1
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
    
//    func beaconBroadcast(){
//        
//        let major:UInt16 = 29
//        let minor:UInt16 = 1
//        let uuid = NSUUID(UUIDString: "0CF052C2-97CA-407C-84F8-B62AAC4E95634")
////        
////        let region = CLBeaconRegion(proximityUUID: uuid!, major: major, minor: minor, identifier: "Test)
//    }
    
}