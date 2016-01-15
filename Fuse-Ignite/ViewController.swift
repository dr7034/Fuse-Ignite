//
//  ViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 12/01/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        
        //Perform Log In with Parse
        
        PFUser.logInWithUsernameInBackground(userEmail!, password: userPassword!) { (user: PFUser?, error: NSError?) -> Void in
            var userMessage = "Welcome!"
            
            if(user != nil)
            {
                //Remember the sign in state
                let userName: String = (user?.username)!
                
                NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "user_name")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                
                //Navigate to Protected Page
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                var mainPage:MainPageViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
                
                var mainPageNav = UINavigationController(rootViewController: mainPage)
                
                var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.window?.rootViewController = mainPageNav
                
            } else {
                
                userMessage = error!.localizedDescription
                
                
                //Create Alert
                var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                
                //Create Alert Action Button
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                //Add Action button to Alert
                myAlert.addAction(okAction)
                
                self.presentViewController(myAlert, animated: true, completion: nil)
                
            }

            
        }
    }
}

