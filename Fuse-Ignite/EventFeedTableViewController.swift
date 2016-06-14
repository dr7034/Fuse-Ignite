//
//  EventFeedTableViewController.swift
//  Fuse-Ignite
//

import UIKit
import Parse
import ParseUI

class EventFeedTableViewController: UITableViewController {
    
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var currentDateTime: UILabel!
    
    var refresher = UIRefreshControl()
    
    var usernameArray = [String]()
    var avatarArray = [PFFile]()
    var imageArray = [PFFile]()
    var dateArray = [Date?]()
    var titleArray = [String]()
    var uuidArray = [String]()
    
    var followArray = [String]()
    
    var page: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Clears Badges on Page open
        let currentInstallation = PFInstallation.current()
        currentInstallation.badge = 0
        
        loadProfilePicture()
        currentDate()
//        
//        refresher.addTarget(self, action: #selector(EventFeedTableViewController.loadPosts), forControlEvents: UIControlEvents.ValueChanged)
//        tableView.addSubview(refresher)
        
        //call function to load posts
//        loadPosts()
        
        //dynamic cell height
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 450
        
    }
    
    //load posts
//    func loadPosts() {
//       let followQuery = PFQuery(className: "Followers")
//        followQuery.whereKey("follower", equalTo: (PFUser.currentUser()?.username)!)
//        followQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
//            if (error == nil) {
//                //clean array
//                self.followArray.removeAll(keepCapacity: false)
//                
//                for object in objects! {
//                    self.followArray.append(object.objectForKey("following") as! String)
//                }
//                self.followArray.append(PFUser.currentUser()!.username!)
//                
//                //find posts made by users you are following
//                let query = PFQuery(className: "UpdateObject")
//                query.whereKey("username", containedIn: self.followArray)
//                query.limit = self.page
//                query.addDescendingOrder("createdAt")
//                query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) in
//                    if (error == nil) {
//                        
//                    //clean up
//                    self.usernameArray.removeAll(keepCapacity: false)
//                    self.avatarArray.removeAll(keepCapacity: false)
//                    self.imageArray.removeAll(keepCapacity: false)
//                    self.dateArray.removeAll(keepCapacity: false)
//                    self.titleArray.removeAll(keepCapacity: false)
//                    self.uuidArray.removeAll(keepCapacity: false)
//                        
//                    for object in objects! {
//                        self.usernameArray.append(object.objectForKey("username") as! String)
//                        
//                        self.avatarArray.append(object.valueForKey("avatar") as! PFFile)
//
//                        self.imageArray.append(object.valueForKey("postImage") as! PFFile)
//                        
//                        self.dateArray.append(object.createdAt)
//                        self.titleArray.append(object.valueForKey("caption") as! String)
//                        self.uuidArray.append(object.valueForKey("objectId") as! String)
//                        }
//                        self.tableView.reloadData()
//                        self.refresher.endRefreshing()
//                    } else {
//                        print(error!.localizedDescription)
//                    }
//                })
//            } else {
//                print(error!.localizedDescription)
//            }
//        }
//    }
////
////    //scroll down
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height {
//            loadMore()
//        }
//    }
//    
//    func loadMore() {
//        if page <= uuidArray.count {
//            
//            //increase page size to load 10 more posts
//            page = page + 10
//            
//            let followQuery = PFQuery(className: "Followers")
//            followQuery.whereKey("follower", equalTo: (PFUser.currentUser()?.username)!)
//            followQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
//                if (error == nil) {
//                    //clean array
//                    self.followArray.removeAll(keepCapacity: false)
//                    
//                    for object in objects! {
//                        self.followArray.append(object.objectForKey("following") as! String)
//                    }
//                    self.followArray.append(PFUser.currentUser()!.username!)
//                    
//                    //find posts made by users you are following
//                    let query = PFQuery(className: "UpdateObject")
//                    query.whereKey("username", containedIn: self.followArray)
//                    query.limit = self.page
//                    query.addDescendingOrder("createdAt")
//                    query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) in
//                        if (error == nil) {
//                            
//                            //clean up
//                            self.usernameArray.removeAll(keepCapacity: false)
//                            self.avatarArray.removeAll(keepCapacity: false)
//                            self.imageArray.removeAll(keepCapacity: false)
//                            self.dateArray.removeAll(keepCapacity: false)
//                            self.titleArray.removeAll(keepCapacity: false)
//                            
//                            for object in objects! {
//                                self.usernameArray.append(object.objectForKey("username") as! String)
//                                self.avatarArray.append(object.valueForKey("avatar") as! PFFile!)
//                                self.imageArray.append(object.valueForKey("postImage") as! PFFile)
//                                
//                                self.dateArray.append(object.createdAt)
//                                self.titleArray.append(object.valueForKey("caption") as! String)
//                                self.uuidArray.append(object.valueForKey("objectId") as! String)
//                            }
//                            self.tableView.reloadData()
//                        } else {
//                            print(error!.localizedDescription)
//                        }
//                    })
//                } else {
//                    print(error!.localizedDescription)
//                }
//            }
//
//        }
//    }
    
    // MARK: - Table view data source
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return uuidArray.count
//    }

    

//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> EventFeedTableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("eventFeedCell", forIndexPath: indexPath) as! EventFeedTableViewCell
//        
//        cell.usernameButton.setTitle(usernameArray[indexPath.row], forState: UIControlState.Normal)
//        cell.postTitleLabel.text = titleArray[indexPath.row]
//        
//        //set profile picture
//        avatarArray[indexPath.row].getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) in
//            cell.avatarImageView.image = UIImage(data: data!)
//        }
//        //set post image
//        imageArray[indexPath.row].getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) in
//            cell.postImageView.image = UIImage(data: data!)
//        }
//        
//        //calculate post date
//        let from = dateArray[indexPath.row]
//        let now = NSDate()
//        let components: NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfMonth]
//        let difference = NSCalendar.currentCalendar().components(components, fromDate: from!, toDate: now, options: [])
//        
//        //date label business logic
//        if (difference.second > 0) {
//            cell.timeSincePostLabel.text = "now"
//        }
//        if (difference.second > 0 && difference.minute == 0) {
//            cell.timeSincePostLabel.text = "\(difference.second)s"
//        }
//        if (difference.minute > 0 && difference.hour == 0) {
//            cell.timeSincePostLabel.text = "\(difference.minute)m"
//        }
//        if (difference.hour > 0 && difference.day == 0) {
//            cell.timeSincePostLabel.text = "\(difference.hour)h"
//        }
//        if (difference.day > 0 && difference.weekOfMonth == 0) {
//            cell.timeSincePostLabel.text = "\(difference.day)d"
//        }
//        if (difference.weekOfMonth > 0) {
//            cell.timeSincePostLabel.text = "\(difference.weekOfMonth)w"
//        }
//        
//        
//        //        //manipulate like button based on user like
//        let didLike = PFQuery(className: "likes")
//        didLike.whereKey("sender", equalTo: PFUser.currentUser()!.username!)
//        didLike.whereKey("recipient", equalTo: cell.hiddenUUIDLabel.text!)
//        didLike.countObjectsInBackgroundWithBlock { (count: Int32, error: NSError?) in
//            //if no likes are found, else found likes
//            if (count == 0) {
//                cell.likesButton.setBackgroundImage(UIImage(named: "unlikeButton"), forState: .Normal)
//            } else {
//                cell.likesButton.setBackgroundImage(UIImage(named: "likeButton"), forState: .Normal)
//            }
//        }
//        //count likes of post
//        let countLikes = PFQuery(className: "Likes")
//        countLikes.whereKey("recipient", equalTo: cell.hiddenUUIDLabel.text!)
//        countLikes.countObjectsInBackgroundWithBlock { (count: Int32, error: NSError?) in
//            cell.likeLabel.text = "\(count)"
//        }
//        
//        cell.usernameButton.layer.setValue(indexPath, forKey: "index")
//        
//        return cell
//    }
//    
//    @IBAction func clickedUsernameButton(sender: AnyObject) {
//        
//        //call index of button
//        let i = sender.layer.valueForKey("index") as! NSIndexPath
//        
//        //call cell to call further cell data
//        let cell = tableView.cellForRowAtIndexPath(i) as! PostTableViewCell
//        
//        //if user tapped on themselves go home otherwise go to visitor page
//        if (cell.usernameButton.titleLabel == PFUser.currentUser()?.username) {
//            let home = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
//            self.navigationController?.pushViewController(home, animated: true)
//        } else {
//            visitorName.append(cell.usernameButton.titleLabel!.text!)
//            let visitor = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileVisitorViewController") as! ProfileVisitorViewController
//            self.navigationController?.pushViewController(visitor, animated: true)
//        }
//    }
    
    @IBAction func leftSideButtonTapped(_ sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    @IBAction func rightSideButtonTapped(_ sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
        appDelegate.drawerContainer?.toggle(MMDrawerSide.right, animated: true, completion: nil)
    }
    
    func loadProfilePicture(){
        
        let profilePictureObject = PFUser.current()?.object(forKey: "profile_picture") as! PFFile
        
        profilePictureObject.getDataInBackground { (imageData: Data?, error: NSError?) -> Void in
            if(imageData != nil)
            {
                self.userProfilePicture.image = UIImage(data: imageData!)
            }
        }
        self.userProfilePicture.layer.cornerRadius = self.userProfilePicture.frame.size.width / 2;
        self.userProfilePicture.clipsToBounds = true;
    }
    
    func currentDate(){
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let convertedDate = dateFormatter.string(from: currentDate)
        self.currentDateTime.text = convertedDate
    }
}
