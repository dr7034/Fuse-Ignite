//  Created by Daniel Reilly on 20/04/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.

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
    @IBOutlet weak var usernameLabel: UILabel!
}

var eventObjectId = String()

class EventHomeSocialTableViewController: PFQueryTableViewController {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationNameLabel: UILabel!
    @IBOutlet weak var eventLocationAddress1Label: UILabel!
    @IBOutlet weak var eventLocationPostcodeLabel: UILabel!
    @IBOutlet weak var eventLocationCountryLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var userProfilePictureImage: UIImageView!
    @IBOutlet weak var userJoinEventButton: UIButton!
    @IBOutlet weak var eventObjectLabel: UILabel!
    
    var window: UIWindow?
    var drawerContainer: MMDrawerController?
    
    // Container to store the view table selected object
    var currentObject : PFObject?
    
    var usernameArray = [String]()
    var profilePictureArray = [PFFile]()
    
    var followArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userJoinEventButton.layer.cornerRadius = self.userJoinEventButton.frame.size.width / 2;
        self.userJoinEventButton.clipsToBounds = true;
        
        // Unwrap the current object object
        if let object = currentObject {
            eventObjectLabel.text = object.objectId
            eventNameLabel.text = object["eventName"] as? String
            eventLocationNameLabel.text = object["eventLocationName"] as? String
            eventLocationAddress1Label.text = object["eventAddress1"] as? String
            eventLocationPostcodeLabel.text = object["eventPostcode"] as? String
            eventLocationCountryLabel.text = object["eventCountry"] as? String
            eventDescriptionLabel.text = object["eventDescription"] as? String
            self.eventDescriptionLabel.sizeToFit()
            
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

        
        if let avatar = object?.objectForKey("profile_picture") as? PFFile {
            avatar.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                    if(error == nil && data != nil) {
                        if let image = UIImage(data: data!)
                        {
                                cell?.userProfilePicture.image = image
                            cell?.userProfilePicture.layer.cornerRadius = (cell?.userProfilePicture.frame.size.width)! / 2;
                            cell?.userProfilePicture.clipsToBounds = true;
                        }
                }
            }
        }

        if let relevantUsers = object?["fullName"] as? String {
            cell?.userFullName?.text = relevantUsers
        }

        if let username = object?["username"] as? String {
            cell?.usernameLabel?.text = username
        }
        
        if let userInterests = object?["userInterests"] as? NSArray {
            cell?.userInterests?.text = userInterests.componentsJoinedByString(", ")
        } else {
            cell?.userInterests?.text = "No interests yet Entered"
        }
        
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
        //recall cell to call cells data
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! RelevantUsersCustomCell
        //if user tapped on themselves, go home else go visitor
        if cell.usernameLabel.text! == PFUser.currentUser()!.username! {
            let myProfile = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(myProfile, animated: true)
        } else {
            visitorName.append(cell.usernameLabel.text!)
            let visitor = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileVisitorViewController") as! ProfileVisitorViewController
            self.navigationController?.pushViewController(visitor, animated: true)
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
                self.userProfilePictureImage.layer.cornerRadius = self.userProfilePictureImage.frame.size.width / 2;
                self.userProfilePictureImage.clipsToBounds = true;
            }
        }
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func userJoinEvent(sender: UIButton) {

        }
}