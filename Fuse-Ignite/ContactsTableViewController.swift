//
//  ContactsTableViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 03/03/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import ParseUI

var eventNameObject = [String]()

class ContactsTableViewController: PFQueryTableViewController {
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "_User"
        self.textKey = "fullName"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "_User")
        query.orderByAscending("fullName")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> ContactsTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("contactsCell") as! ContactsTableViewCell!
        if cell == nil {
            cell = ContactsTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "contactsCell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let contactName = object?["fullName"] as? String {
            cell?.userFullNameLabel?.text = contactName
        }
        if let contactEmail = object?["email"] as? String {
            cell?.userEmailAddressLabel?.text = contactEmail
        }
        if let contactUsername = object?["username"] as? String {
            cell?.usernameLabel?.text = contactUsername
        }
        return cell
    }
    
    func returnEventObject() {

    let eventNameQuery = PFQuery(className: "eventObject")
        eventNameQuery.findObjectsInBackgroundWithBlock { (object:[PFObject]?, error:NSError?) in
       
            if(eventNameObject.isEmpty) {
                eventNameObject.removeAll()
            }
            
        }
    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //recall cell to call cells data
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ContactsTableViewCell
        
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

}
