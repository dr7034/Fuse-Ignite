//
//  EventFeedTableViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 26/01/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse

class EventFeedTableViewController: UITableViewController {
    
    var selectedUser: PFUser?
    var eventFeedItems = [PFObject]()

    @IBOutlet var eventFeedTable: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadEventFeed(selectedUser!)
    
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return eventFeedItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCellWithIdentifier("EventFeedCell", forIndexPath: indexPath)
        
        let eventItem = eventFeedItems[indexPath.row]
        let eventTitle = eventItem.objectForKey("eventName") as? String
        
        eventCell.textLabel?.text = eventTitle
        
        return eventCell
    }
    
    func loadEventFeed(selectedUser: PFUser)
    {
        let eventQuery = PFQuery(className: "EventObject")
        eventQuery.whereKey("eventCreator", equalTo: selectedUser)
        eventQuery.includeKey("eventCreator")
        
        eventQuery.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) -> Void in
            
            if let searchResults = result
            {
                self.eventFeedItems = searchResults
                self.eventFeedTable.reloadData()
            }
            
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
