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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("contactsCell") as! PFTableViewCell!
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "contactsCell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let contactName = object?["fullName"] as? String {
            cell?.textLabel?.text = contactName
        }
        if let eventDescription = object?["email"] as? String {
            cell?.detailTextLabel?.text = eventDescription
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
    
    @IBAction func leftSideButtonTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }
    
    
    @IBAction func rightSideButtonTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
    }

}
