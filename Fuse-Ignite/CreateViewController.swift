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

    @IBAction func leftSideButtonTapped(_ sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
    }
    
    @IBAction func rightSideButtonTapped(_ sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.shared().delegate as! AppDelegate
        
        appDelegate.drawerContainer?.toggle(MMDrawerSide.right, animated: true, completion: nil)
        
    }
    
    @IBAction func addCoverImageButtonTapped(_ sender: AnyObject) {
        
    }
    
    @IBAction func isFacebookConnected(_ sender: AnyObject) {
    }
    
    @IBAction func isTwitterConnected(_ sender: AnyObject) {
    }

    @IBAction func isInstagramConnected(_ sender: AnyObject) {
    }
    
    
    @IBAction func isYouTubeConnected(_ sender: AnyObject) {
    }
    

    @IBAction func createEventSubmitButton(_ sender: AnyObject) {
        
        let eventName = createEventNameTextField.text!
        let eventDescription = createEventDescriptionTextField.text!
        let eventContactEmail = createEventContactEmailTextField.text!
        let eventLocationName = createEventLocationNameTextField.text!
        
        
        
        let event = PFObject(className: "EventObject")
        event.setObject(eventName, forKey: "eventName")
        event.setObject(eventDescription, forKey: "eventDescription")
        event.setObject(eventContactEmail, forKey: "contactEmail")
        event.setObject(eventLocationName, forKey: "eventLocationName")
        event.saveInBackground { (success, error) in
            if success == true {
                self.displayMessage("Event Created!")
            } else {
                self.displayMessage((error?.localizedDescription)!)
            }
        }
    }
    
    
    func displayMessage(_ userMessage:String)
    {
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            action in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
