//
//  DiscoverTableViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 27/02/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DiscoverTableViewController: PFQueryTableViewController {

    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "EventObject"
        self.textKey = "eventName"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "EventObject")
        query.orderByAscending("eventName")
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showEvent", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let nav = segue.destinationViewController as! UINavigationController
        let eventViewController = nav.topViewController as! EventHomeSocialTableViewController
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let row = Int(indexPath.row)
            eventViewController.currentObject = (objects?[row]) as? PFObject
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
