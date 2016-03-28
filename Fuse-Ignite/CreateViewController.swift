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
    @IBOutlet weak var createEventLocationTextField: UITextField!
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
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
