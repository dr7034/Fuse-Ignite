//
//  PostViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 25/05/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import ParseUI

var postuuid = [String]()

class PostViewController: UITableViewController {
    
    var usernameArray = [String]()
    var avatarArray = [PFFile]()
    var imageArray = [PFFile]()
    var dateArray = [NSDate?]()
    var titleArray = [String]()
    var uuidArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Post"

        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: "back")
        self.navigationItem.leftBarButtonItem = backButton
        
        //SWIPE TO GO BACK
        let backSwipe = UISwipeGestureRecognizer(target: self, action: "back")
        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(backSwipe)
        
        //dynamic cell height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 450
        
        let postQuery = PFQuery(className: "UpdateObject")
        postQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if(error == nil) {
                
                //clean up
                self.usernameArray.removeAll(keepCapacity: false)
                self.avatarArray.removeAll(keepCapacity: false)
                self.imageArray.removeAll(keepCapacity: false)
                self.dateArray.removeAll(keepCapacity: false)
                self.titleArray.removeAll(keepCapacity: false)
                
                for object in objects! {
                    self.avatarArray.append(object.valueForKey("avatar") as! PFFile)
                    self.usernameArray.append(object.valueForKey("username") as! String)
                    self.imageArray.append(object.valueForKey("postImage") as! PFFile)
                    self.dateArray.append(object.createdAt)
                    self.titleArray.append(object.valueForKey("title") as! String)
                }
            }
        }
    }

    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostTableViewCell
        
        cell.usernameButton.setTitle(usernameArray[indexPath.row], forState: UIControlState.Normal)
        cell.uuidHiddenLabel.text = uuidArray[indexPath.row]
        cell.titleLabel.text = titleArray[indexPath.row]
        
        //set profile picture
        avatarArray[indexPath.row].getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) in
            cell.avatarImage.image = UIImage(data: data!)
        }
        //set post image
        imageArray[indexPath.row].getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) in
            cell.postImageView.image = UIImage(data: data!)
        }
        
        //calculate post date
        let from = dateArray[indexPath.row]
        let now = NSDate()
        let components: NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfMonth]
        let difference = NSCalendar.currentCalendar().components(components, fromDate: from!, toDate: now, options: [])
        
        //date label business logic
        if (difference.second > 0) {
            cell.dateLabel.text = "now"
        }
        if (difference.second > 0 && difference.minute == 0) {
            cell.dateLabel.text = "\(difference.second)s"
        }
        if (difference.minute > 0 && difference.hour == 0) {
            cell.dateLabel.text = "\(difference.minute)m"
        }
        if (difference.hour > 0 && difference.day == 0) {
            cell.dateLabel.text = "\(difference.hour)h"
        }
        if (difference.day > 0 && difference.weekOfMonth == 0) {
            cell.dateLabel.text = "\(difference.day)d"
        }
        if (difference.weekOfMonth > 0) {
            cell.dateLabel.text = "\(difference.weekOfMonth)w"
        }
        
        
//        //manipulate like button based on user like
        let didLike = PFQuery(className: "likes")
        didLike.whereKey("sender", equalTo: PFUser.currentUser()!.username!)
        didLike.whereKey("recipient", equalTo: cell.uuidHiddenLabel.text!)
        didLike.countObjectsInBackgroundWithBlock { (count: Int32, error: NSError?) in
            //if no likes are found, else found likes
            if (count == 0) {
                cell.likesButton.setBackgroundImage(UIImage(named: "unlikeButton"), forState: .Normal)
            } else {
                cell.likesButton.setBackgroundImage(UIImage(named: "likeButton"), forState: .Normal)
            }
        }
        //count likes of post
        let countLikes = PFQuery(className: "Likes")
        countLikes.whereKey("recipient", equalTo: cell.uuidHiddenLabel.text!)
        countLikes.countObjectsInBackgroundWithBlock { (count: Int32, error: NSError?) in
            cell.likeLabel.text = "\(count)"
        }
        
        cell.usernameButton.layer.setValue(indexPath, forKey: "index")
        
        return cell
    }
    
    @IBAction func clickedUsernameButton(sender: AnyObject) {
        
        //call index of button
        let i = sender.layer.valueForKey("index") as! NSIndexPath
        
        //call cell to call further cell data
        let cell = tableView.cellForRowAtIndexPath(i) as! PostTableViewCell
        
        //if user tapped on themselves go home otherwise go to visitor page
        if (cell.usernameButton.titleLabel?.text == PFUser.currentUser()?.username) {
            let home = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            visitorName.append(cell.usernameButton.titleLabel!.text!)
            let visitor = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileVisitorViewController") as! ProfileVisitorViewController
            self.navigationController?.pushViewController(visitor, animated: true)
        }
        
    }
    
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
        
        if(!postuuid.isEmpty) {
            postuuid.removeLast()
        }
        
    }
    
}
