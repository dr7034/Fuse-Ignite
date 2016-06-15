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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func signInButtonTapped(_ sender: AnyObject) {
        
        let userEmail = userEmailAddressTextField!.text
        let userPassword = userPasswordTextField!.text
        
        if(userEmail!.isEmpty || userPassword!.isEmpty)
        {
            return displayMessage("Please fill in all fields")
        }
        
        let activityIndicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        activityIndicator?.labelText = "Sending"
        activityIndicator?.detailsLabelText = "Please wait"
        
        //Perform Log In with Parse
        
        PFUser.logInWithUsername(inBackground: userEmail!, password: userPassword!) { (user: PFUser?, error: NSError?) in
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            var userMessage = "Welcome!"
            
            if(user != nil)
            {
                //Remember the sign in state
                let userName: String = (user?.username)!
                
                UserDefaults.standard().set(userName, forKey: "user_name")
                UserDefaults.standard().synchronize()
                
                
                //Navigate to Protected Page
                
                let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
                
                appDelegate.buildUserInterface()
                
            } else {
                
                userMessage = error!.localizedDescription
                self.displayMessage(userMessage)
            }
        }
    }
    
    @IBAction func facebookLoginButtonTapped(_ sender: AnyObject) {
        
        let permissions = ["public_profile","email"]
        
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions, block: { (user:PFUser?, error:NSError?) -> Void in
            
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
        let activityIndicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        activityIndicator?.labelText = "Fetching Data"
        activityIndicator?.detailsLabelText = "Please Wait"
        
        // Define fields we would like to read from Facebook User object
        let requestParameters: AnyObject = ["fields": "id, email, name"]
        
        // /me
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters as! [NSObject : AnyObject])
        
        userDetails?.start(completionHandler: { (connection: FBSDKGraphRequestConnection?, result: AnyObject?, error: NSError?) in
        
            if(error != nil)
            {
                //Enter Activity Indicator
                activityIndicator?.hide(true)
                
                //display an error message
                let userMessage = error!.localizedDescription
                self.displayMessage(userMessage)
                
                //If Error, Log User Out of Application
                PFUser.logOut()
                
                return
            }
            
            //Extract user fields
            let userId: String = "id"
            let userFullName:String = "fullName"
            let userEmail = "email"
            
            //Get Facebook Profile Picture
            let userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
            
            let profilePictureUrl = URL(string: userProfile)
            
            let profilePictureData = try? Data(contentsOf: profilePictureUrl!)
            
            //Prepare PFUser Object
            
            //Store Profile Picture
            if(profilePictureData != nil)
            {
                let profileFileObject = PFFile(data:profilePictureData!)
                PFUser.current()?.setObject(profileFileObject, forKey: "profile_picture")
            }
            
            PFUser.current()?.setObject(userFullName, forKey: "fullName")
            
            if userEmail == userEmail
            {
                PFUser.current()?.email = userEmail
                PFUser.current()?.username = userEmail
                
                //TODO: Log Out User If Email does not exist
                
            }
            
            PFUser.current()?.saveInBackground({ (success:Bool, error:NSError?) -> Void in
                
                activityIndicator?.hide(true)
                
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
                        UserDefaults.standard().set(userId, forKey: "username")
                        UserDefaults.standard().synchronize()
                        
                        //Take user to Main Page through the Segue in AppDelegate asyncronously
                        DispatchQueue.main.async {
                            let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
                            appDelegate.buildUserInterface()
                            
                            }
                        }
                    }
                })
            })
        }
        
    func displayMessage(_ userMessage:String)
    {
        //Create Alert
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        //Create Alert Action Button
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            action in
            self.dismiss(animated: true, completion: nil)
        }
        
        //Add Action button to Alert
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
