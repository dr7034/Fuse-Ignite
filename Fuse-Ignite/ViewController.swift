//
//  ViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 12/01/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import ParseTwitterUtils

class ViewController: UIViewController {

    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailAddressTextField!.text
        let userPassword = userPasswordTextField!.text
        
        if(userEmail!.isEmpty || userPassword!.isEmpty)
        {
            return
        }
        
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.labelText = "Sending"
        activityIndicator.detailsLabelText = "Please wait"
        
        //Perform Log In with Parse
        
        PFUser.logInWithUsernameInBackground(userEmail!, password: userPassword!) { (user: PFUser?, error: NSError?) -> Void in
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            var userMessage = "Welcome!"
            
            if(user != nil)
            {
                //Remember the sign in state
                let userName: String = (user?.username)!
                
                NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "user_name")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                
                //Navigate to Protected Page
                
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.buildUserInterface()
                
            } else {
                
                userMessage = error!.localizedDescription
                self.displayMessage(userMessage)
            }
        }
    }
    
    @IBAction func facebookLoginButtonTapped(sender: AnyObject) {
        
        let permissions = ["public_profile","email"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: { (user:PFUser?, error:NSError?) -> Void in
            
            if(error != nil) {
                //display an error message
                let userMessage = error!.localizedDescription
                self.displayMessage(userMessage)
                
                return
                
            }
            
            //Load facebook details [First Name, Last Name, Email, Profile Picture]
            self.loadFacebookUserDetails()
            
        })
        
    }
    
    func loadFacebookUserDetails() {
        
        //Display Activity Indicator
        let activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator.labelText = "Fetching Data"
        activityIndicator.detailsLabelText = "Please Wait"
        
        // Define fields we would like to read from Facebook User object
        let requestParameters = ["fields": "id, email, first_name, last_name, name"]
        
        // /me
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        
        userDetails.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            
            if(error != nil)
            {
                //Enter Activity Indicator
                activityIndicator.hide(true)
                
                //display an error message
                let userMessage = error!.localizedDescription
                self.displayMessage(userMessage)
                
                //If Error, Log User Out of Application
                PFUser.logOut()
                
                return
            }
            
            //Extract user fields
            let userId:String = result["id"] as! String
//            let userFullName:String = result["name"] as! String
            let userEmail:String? = result["email"] as? String
            let userFirstName:String?  = result["first_name"] as? String
            let userLastName:String? = result["last_name"] as? String
            
            //Get Facebook Profile Picture
            let userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
            
            let profilePictureUrl = NSURL(string: userProfile)
            
            let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
            
            //Prepare PFUser Object
            
            //Store Profile Picture
            if(profilePictureData != nil)
            {
                let profileFileObject = PFFile(data:profilePictureData!)
                PFUser.currentUser()?.setObject(profileFileObject, forKey: "profile_picture")
            }
            
            PFUser.currentUser()?.setObject(userFirstName!, forKey: "first_name")
            PFUser.currentUser()?.setObject(userLastName!, forKey: "last_name")
            
            
            if let userEmail = userEmail
            {
                PFUser.currentUser()?.email = userEmail
                PFUser.currentUser()?.username = userEmail
                
                //TODO: Log Out User If Email does not exist
                
            }
            
            PFUser.currentUser()?.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                
                activityIndicator.hide(true)
                
                if(error != nil)
                {
                //display an error message
                    let userMessage = error!.localizedDescription
                    
                    //shows alert
                    self.displayMessage(userMessage)
                    PFUser.logOut()
                    
                    return
                }

                if(success)
                {
                    if !userId.isEmpty
                    {
                        NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "user_name")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        //Take user to Main Page through the Segue in AppDelegate asyncronously
                        dispatch_async(dispatch_get_main_queue()) {
                            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelegate.buildUserInterface()
                            
                            }
                        }
                    }
                })
            })
        }
        
    func displayMessage(userMessage:String)
    {
        //Create Alert
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        //Create Alert Action Button
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
        {
            action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        //Add Action button to Alert
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}