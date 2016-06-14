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
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PasswordResetViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @IBAction func SendEmailButtonTapped(_ sender: AnyObject) {
        
        let emailAddress = emailAddressTextField.text
        
        if(emailAddress!.isEmpty)
        {
            let userMessage:String = "Please Type in your Email Address"
            self.displayMessage(userMessage)
            
            return
        }
        
        PFUser.requestPasswordResetForEmail(inBackground: emailAddress!) { (success:Bool, error:NSError?) -> Void in
            
            if(error != nil)
            {
                //Display Error Message
                let userMessage:String = error!.localizedDescription
                self.displayMessage(userMessage)
            } else {
                //Display Success Message
                let userMessage:String = "Password Reset Email Sent to \(self.emailAddressTextField.text)"
                self.displayMessage(userMessage)
                
            }
            
        }
        
    }
    
    func displayMessage(_ userMessage:String)
    {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            action in
            self.dismiss(animated: true, completion: nil)
        }
        
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }

    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
