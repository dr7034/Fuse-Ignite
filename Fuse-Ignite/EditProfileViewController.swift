//
//  EditProfileViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 16/01/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userFirstNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userPasswordRepeatTextField: UITextField!
    @IBOutlet weak var userCompanyNameTextField: UITextField!
    @IBOutlet weak var userJobTitleTextField: UITextField!
    
    var opener: LeftSideViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        // Load User Details
        let userFirstName = PFUser.currentUser()?.objectForKey("fullName") as? String
        let userCompanyName = PFUser.currentUser()?.objectForKey("companyName") as? String
        let userJobTitle = PFUser.currentUser()?.objectForKey("jobTitle") as? String
        
        userFirstNameTextField.text = userFirstName
        userCompanyNameTextField.text = userCompanyName
        userJobTitleTextField.text = userJobTitle
        
        if(PFUser.currentUser()?.objectForKey("profile_picture") != nil)
        {
            let userImageFile:PFFile = PFUser.currentUser()?.objectForKey("profile_picture") as! PFFile
            
            userImageFile.getDataInBackgroundWithBlock({ (imageData:NSData?, error:NSError?) -> Void in
                
                if(imageData != nil)
                {
                self.profilePictureImageView.image = UIImage(data: imageData!)
                self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2;
                self.profilePictureImageView.clipsToBounds = true;
                }
            })
        }
    }
    
    @IBAction func changeProfilePictureButtonTapped(sender: AnyObject) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        profilePictureImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        //Get Current User
        let myUser:PFUser = PFUser.currentUser()!
        
        //Get profile image
        let profileImageData = UIImageJPEGRepresentation(profilePictureImageView.image!, 1)
        
        //Check if all fields are empty
        if(userPasswordTextField.text!.isEmpty && userFirstNameTextField.text!.isEmpty && (profileImageData == nil))
        {
            let userMessage = "All Fields cannot be empty"
            self.displayMessage(userMessage)
        }
        
        //Check if Passwords Match
        if(userPasswordTextField.text != userPasswordRepeatTextField.text)
        {
            let userMessage =  "Passwords Must Match"
            self.displayMessage(userMessage)
        }
        
        //Check if First name or Last name are not empty
        if(userFirstNameTextField.text!.isEmpty)
        {
            let userMessage = "Name Field is Required"
            self.displayMessage(userMessage)
        }
        
        //Set New Values for First and Last Name
        let userFirstName = userFirstNameTextField.text!
        
        myUser.setObject(userFirstName, forKey: "fullName")
        
        // Set New Password
        if(userPasswordTextField.text != nil)
        {
            let userPassword = userPasswordTextField.text
            myUser.password = userPassword
        }
        
        //Set Profile Picture
        if(profileImageData != nil)
        {
            let profileFileObject = PFFile(data: profileImageData!)
            myUser.setObject(profileFileObject, forKey: "profile_picture")
        }
        
        //Display Activity Indicator
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = "Updating Info."
        loadingNotification.detailsLabelText = "Please Wait..."
        
        //Save in Data in Background with Block
        
        myUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            //Hide Activity Indicator
            loadingNotification.hide(true)
            
            if(error != nil)
            {
                let userMessage = error!.localizedDescription
                self.displayMessage(userMessage)
            }
            
            if(success)
            {
                let userMessage = "Profile details successfully updated"
                self.displayMessage(userMessage)
                
            }
        }
    }
    
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func displayMessage(userMessage:String)
    {
        //Create Alert
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        //Create Alert Action Button
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action in self.dismissViewControllerAnimated(true, completion: nil)
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