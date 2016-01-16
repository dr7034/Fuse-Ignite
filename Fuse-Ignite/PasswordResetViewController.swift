//
//  PasswordResetViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 16/01/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse

class PasswordResetViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func SendEmailButtonTapped(sender: AnyObject) {
        
        let emailAddress = emailAddressTextField.text
        
        if(emailAddress!.isEmpty)
        {
            let userMessage:String = "Please Type in your Email Address"
            self.displayMessage(userMessage)
            
            return
        }
        
        PFUser.requestPasswordResetForEmailInBackground(emailAddress!) { (success:Bool, error:NSError?) -> Void in
            
            if(error != nil)
            {
                //Display Error Message
                let userMessage:String = error!.localizedDescription
                self.displayMessage(userMessage)
            } else {
                //Display Success Message
                let userMessage:String = "Password Reset Email Sent to \(emailAddress)"
                self.displayMessage(userMessage)
                
            }
            
        }
        
    }
    
    func displayMessage(userMessage:String)
    {
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
