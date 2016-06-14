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
    override func queryForTable() -> PFQuery<PFObject> {
        let query = PFQuery(className: "_User")
        query.order(byAscending: "fullName")
        return query
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, object: PFObject?) -> ContactsTableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell") as! ContactsTableViewCell!
        if cell == nil {
            cell = ContactsTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "contactsCell")
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
        return cell!
    }
    
    func returnEventObject() {

    let eventNameQuery = PFQuery(className: "eventObject")
        eventNameQuery.findObjectsInBackground { (object:[PFObject]?, error:NSError?) in
       
            if(eventNameObject.isEmpty) {
                eventNameObject.removeAll()
            }
            
        }
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //recall cell to call cells data
        let cell = tableView.cellForRow(at: indexPath) as! ContactsTableViewCell
        
        //if user tapped on themselves, go home else go visitor
        if cell.usernameLabel.text! == PFUser.current()!.username! {
            let myProfile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(myProfile, animated: true)
        } else {
            visitorName.append(cell.usernameLabel.text!)
            let visitor = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVisitorViewController") as! ProfileVisitorViewController
            self.navigationController?.pushViewController(visitor, animated: true)
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
