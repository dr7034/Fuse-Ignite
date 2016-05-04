//
//  CreateViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 16/02/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CreateViewController: UIViewController {

    @IBOutlet weak var createEventNameTextField: UITextField!
    @IBOutlet weak var createEventDescriptionTextField: UITextField!
    @IBOutlet weak var createEventLocationNameTextField: UITextField!
    @IBOutlet weak var createEventContactEmailTextField: UITextField!
    
    override func viewDidLoad() {
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @IBAction func leftSideButtonTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
    }
    
    @IBAction func rightSideButtonTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
    }
    
    @IBAction func addCoverImageButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func isFacebookConnected(sender: AnyObject) {
    }
    
    @IBAction func isTwitterConnected(sender: AnyObject) {
    }

    @IBAction func isInstagramConnected(sender: AnyObject) {
    }
    
    
    @IBAction func isYouTubeConnected(sender: AnyObject) {
    }
    

    @IBAction func createEventSubmitButton(sender: AnyObject) {
        
        let eventName = createEventNameTextField.text!
        let eventDescription = createEventDescriptionTextField.text!
        let eventContactEmail = createEventContactEmailTextField.text!
        let eventLocationName = createEventLocationNameTextField.text!
        
        
        
        let event = PFObject(className: "EventObject")
        event.setObject(eventName, forKey: "eventName")
        event.setObject(eventDescription, forKey: "eventDescription")
        event.setObject(eventContactEmail, forKey: "contactEmail")
        event.setObject(eventLocationName, forKey: "eventLocationName")
        event.saveInBackgroundWithBlock { (success, error) in
            if success == true {
                self.displayMessage("Event Created!")
            } else {
                self.displayMessage((error?.localizedDescription)!)
            }
        }
    }
    
    
    func displayMessage(userMessage:String)
    {
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
