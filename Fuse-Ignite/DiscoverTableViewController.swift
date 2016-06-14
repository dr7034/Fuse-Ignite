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
    override func queryForTable() -> PFQuery<PFObject> {
        let query = PFQuery(className: "EventObject")
        query.order(byAscending: "eventName")
        return query
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "discoverCell") as! PFTableViewCell!
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "discoverCell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let eventName = object?["eventName"] as? String {
            cell?.textLabel?.text = eventName
        }
        if let eventDescription = object?["eventDescription"] as? String {
            cell?.detailTextLabel?.text = eventDescription
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showEvent", sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let nav = segue.destinationViewController as! UINavigationController
        let eventViewController = nav.topViewController as! EventHomeSocialTableViewController
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let row = Int((indexPath as NSIndexPath).row)
            eventViewController.currentObject = (objects?[row]) as? PFObject
        }
        
    }
    
    @IBAction func leftSideButtonTapped(_ sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
    }
    
    @IBAction func rightSideButtonTapped(_ sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggle(MMDrawerSide.right, animated: true, completion: nil)
        
    }
    
}
