//
//  EventFeedTableViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 03/03/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import Parse
import ParseUI

class EventFeedTableViewController: PFQueryTableViewController {
    
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var currentDateTime: UILabel!
    
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
        
        self.parseClassName = "UpdateObject"
        self.textKey = "createdAt"
        self.pullToRefreshEnabled = false
        self.paginationEnabled = false
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> EventFeedTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("eventFeedCell") as! EventFeedTableViewCell!
        if cell == nil {
            cell = EventFeedTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "eventFeedCell")
        }
        
//        if let usernameObject = object?.objectForKey("username") as? String {
//            cell?.usernameButton?.setTitle(usernameObject, forState: .Normal)
//        }
        
//        if let userFullName = object?.objectForKey("fullName") as? String {
//            cell.textLabel?.text = userFullName
//        }
        
//        if let postImageView = object?.objectForKey("avatar") as? PFFile {
//            
//            postImageView.getDataInBackgroundWithBlock
//                { (data: NSData?, error: NSError?) -> Void in
//                    
//                    if(error == nil && data != nil)
//                    {
//                        if let image = UIImage(data: data!)
//                        {
//                            cell.avatarImageView.image = image
//                        }
//                    }
//            }
//        }
        
//        if let postTitleLabel = object?.objectForKey("caption") as? String {
//            cell.detailTextLabel?.text = postTitleLabel
//        }
        
//        tableView.reloadData()
        
        return cell
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "UpdateObject")
        query.orderByDescending("createdAt")
        
        return query
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
