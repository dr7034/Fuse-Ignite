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
    var dateArray = [Date?]()
    var titleArray = [String]()
    var uuidArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Post"

        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.plain, target: self, action: "back")
        self.navigationItem.leftBarButtonItem = backButton
        
        //SWIPE TO GO BACK
        let backSwipe = UISwipeGestureRecognizer(target: self, action: "back")
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        //dynamic cell height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 450
        
        let postQuery = PFQuery(className: "UpdateObject")
        postQuery.findObjectsInBackground { (objects: [PFObject]?, error: NSError?) in
            if(error == nil) {
                
                //clean up
                self.usernameArray.removeAll(keepingCapacity: false)
                self.avatarArray.removeAll(keepingCapacity: false)
                self.imageArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                self.titleArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.avatarArray.append(object.value(forKey: "avatar") as! PFFile)
                    self.usernameArray.append(object.value(forKey: "username") as! String)
                    self.imageArray.append(object.value(forKey: "postImage") as! PFFile)
                    self.dateArray.append(object.createdAt)
                    self.titleArray.append(object.value(forKey: "title") as! String)
                }
            }
        }
    }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        
        cell.usernameButton.setTitle(usernameArray[(indexPath as NSIndexPath).row], for: UIControlState())
        cell.uuidHiddenLabel.text = uuidArray[(indexPath as NSIndexPath).row]
        cell.titleLabel.text = titleArray[(indexPath as NSIndexPath).row]
        
        //set profile picture
        avatarArray[(indexPath as NSIndexPath).row].getDataInBackground { (data: Data?, error: NSError?) in
            cell.avatarImage.image = UIImage(data: data!)
        }
        //set post image
        imageArray[(indexPath as NSIndexPath).row].getDataInBackground { (data: Data?, error: NSError?) in
            cell.postImageView.image = UIImage(data: data!)
        }
        
        //calculate post date
        let from = dateArray[(indexPath as NSIndexPath).row]
        let now = Date()
        let components: Calendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = Calendar.current().components(components, from: from!, to: now, options: [])
        
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
        didLike.whereKey("sender", equalTo: PFUser.current()!.username!)
        didLike.whereKey("recipient", equalTo: cell.uuidHiddenLabel.text!)
        didLike.countObjectsInBackground { (count: Int32, error: NSError?) in
            //if no likes are found, else found likes
            if (count == 0) {
//                cell.likesButton.setTitle("unlike", forState: .Normal)
                cell.likesButton.setBackgroundImage(UIImage(named: "unlikeButton"), for: UIControlState())
            } else {
//                cell.likesButton.setTitle("like", forState: .Normal)
                cell.likesButton.setBackgroundImage(UIImage(named: "likeButton"), for: UIControlState())
            }
        }
        //count likes of post
        let countLikes = PFQuery(className: "Likes")
        countLikes.whereKey("recipient", equalTo: cell.uuidHiddenLabel.text!)
        countLikes.countObjectsInBackground { (count: Int32, error: NSError?) in
            cell.likeLabel.text = "\(count)"
        }
        
        cell.usernameButton.layer.setValue(indexPath, forKey: "index")
        
        return cell
    }
    
    @IBAction func clickedUsernameButton(_ sender: AnyObject) {
        
        //call index of button
        let i = sender.layer.value(forKey: "index") as! IndexPath
        
        //call cell to call further cell data
        let cell = tableView.cellForRow(at: i) as! PostTableViewCell
        
        //if user tapped on themselves go home otherwise go to visitor page
        if (cell.usernameButton.titleLabel?.text == PFUser.current()?.username) {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            visitorName.append(cell.usernameButton.titleLabel!.text!)
            let visitor = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVisitorViewController") as! ProfileVisitorViewController
            self.navigationController?.pushViewController(visitor, animated: true)
        }
        
    }
    
    
    func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
        
        if(!postuuid.isEmpty) {
            postuuid.removeLast()
        }
        
    }
    
}
