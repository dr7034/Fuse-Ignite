//
//  FollowersTableViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 08/05/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import ParseUI

var show = String()
var user = String()

class FollowersTableViewController: UITableViewController {
    
    var usernameArray = [String]()
    var profilePictureArray = [PFFile]()
    
    var followArray = [String]()
    
    override func viewDidLoad() {
        self.navigationItem.title = show.capitalizedString
        
        if(show == "followers") {
            loadFollowers()
        }
        
        if(show == "following") {
            loadFollowing()
        }
    }
    
    func loadFollowers(){
        let followQuery = PFQuery(className: "Followers")
        followQuery.whereKey("following", equalTo: user)
        
        //get followers
        followQuery.findObjectsInBackground { (objects: [PFObject]?, error: NSError?) in
            if(error == nil) {
                self.followArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.followArray.append(object.value(forKey: "follower") as! String)
                }
                let query = PFUser.query()
                query?.whereKey("username", containedIn: self.followArray)
                query?.addDescendingOrder("createdAt")
                
                //get username and profile picture
                query?.findObjectsInBackground({ (objects: [PFObject]?, error:NSError?) in
                if(error == nil) {
                    self.usernameArray.removeAll(keepingCapacity: false)
                    self.profilePictureArray.removeAll(keepingCapacity: false)
                    
                for object in objects! {
                    self.usernameArray.append(object.value(forKey: "username") as! String)
                    self.profilePictureArray.append(object.value(forKey: "profile_picture") as! PFFile)
                    self.tableView.reloadData()
                        }
                } else {
                    print(error?.localizedDescription)
                    }
                })
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    func loadFollowing(){
        let followQuery = PFQuery(className: "Followers")
        followQuery.whereKey("follower", equalTo: user)
        
        //get following
        followQuery.findObjectsInBackground { (objects: [PFObject]?, error: NSError?) in
            if(error == nil) {
                self.followArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.followArray.append(object.value(forKey: "following") as! String)
                }
                
               // find users following the selected user
                let query = PFQuery(className: "_User")
                query.whereKey("username", containedIn: self.followArray)
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackground({ (objects: [PFObject]?, error: NSError?) in
                    if(error == nil) {
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.profilePictureArray.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                            self.usernameArray.append(object.value(forKey: "username") as! String)
                            self.profilePictureArray.append(object.value(forKey: "profile_picture") as! PFFile)
                            self.tableView.reloadData()
                        }
                    } else {
                        print(error?.localizedDescription)
                    }
                })
            } else {
                print(error?.localizedDescription)
            }
        }
    }

    //number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }
    
    //cell configuration
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FollowersCell
        
        //connect data from server to objects
        cell.usernameLabel.text = usernameArray[(indexPath as NSIndexPath).row]
        profilePictureArray[(indexPath as NSIndexPath).row].getDataInBackground { (data:Data?, error:NSError?) in
            if(error == nil) {
                cell.userProfilePictureImage.image = UIImage(data: data!)
                cell.userProfilePictureImage.layer.cornerRadius = cell.userProfilePictureImage.frame.size.width / 2;
                cell.userProfilePictureImage.clipsToBounds = true;
            } else {
                print(error?.localizedDescription)
            }
        }
        
        let query = PFQuery(className: "Followers")
        query.whereKey("follower", equalTo: PFUser.current()!.username!)
        query.whereKey("following", equalTo: cell.usernameLabel.text!)
        query.countObjectsInBackground ({ (count: Int32, error: NSError?) in
            if(error == nil) {
                if(count == 0) {
                    cell.userFollowingButton.setTitle("Follow +", for: UIControlState())
                    cell.userFollowingButton.backgroundColor = .lightGray()
                } else {
                    cell.userFollowingButton.setTitle("Following", for: UIControlState())
                    cell.userFollowingButton.backgroundColor = UIColor.green()
                }
            }
        })
        
        //hide follow button for current user
        if cell.usernameLabel.text == PFUser.current()?.username {
            cell.userFollowingButton.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //recall cell to call cells data
        let cell = tableView.cellForRow(at: indexPath) as! FollowersCell
        
        //if user tapped on themselves, go home else go visitor
        if cell.usernameLabel.text! == PFUser.current()!.username {
            let myProfile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(myProfile, animated: true)
        } else {
            visitorName.append(cell.usernameLabel.text!)
            let visitor = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVisitorViewController") as! ProfileVisitorViewController
            self.navigationController?.pushViewController(visitor, animated: true)
        }
    }
    
}
