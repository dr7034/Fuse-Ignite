//
//  EditProfileViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 16/01/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userFirstNameTextField: UITextField!
    @IBOutlet weak var userLastNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userPasswordRepeatTextField: UITextField!
    
    var opener: LeftSideViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load User Details
        let userFirstName = PFUser.currentUser()?.objectForKey("first_name") as! String
        let userLastName = PFUser.currentUser()?.objectForKey("last_name") as! String
        
        userFirstNameTextField.text = userFirstName
        userLastNameTextField.text = userLastName
        
        if(PFUser.currentUser()?.objectForKey("profile_picture") != nil)
        {
            let userImageFile:PFFile = PFUser.currentUser()?.objectForKey("profile_picture") as! PFFile
            
            userImageFile.getDataInBackgroundWithBlock({ (imageData:NSData?, error:NSError?) -> Void in
                
                if(imageData != nil)
                {
                self.profilePictureImageView.image = UIImage(data: imageData!)
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeProfilePictureButtonTapped(sender: AnyObject) {
        
        var myPickerController = UIImagePickerController()
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
        if(userPasswordTextField.text!.isEmpty && userFirstNameTextField.text!.isEmpty && userLastNameTextField.text!.isEmpty && (profileImageData == nil))
        {
            var myAlert = UIAlertController(title: "Alert", message: "All Fields cannot be empty", preferredStyle: UIAlertControllerStyle.Alert);
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction);
            self.presentViewController(myAlert, animated: true, completion: nil);
            
            return
        }
        
        //Check if Passwords Match
        if(userPasswordTextField.text != userPasswordRepeatTextField.text)
        {
            var myAlert = UIAlertController(title: "Alert", message: "Passwords Must Match", preferredStyle: UIAlertControllerStyle.Alert);
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction);
            self.presentViewController(myAlert, animated: true, completion: nil);
            
            return
        }
        
        //Check if First name or Last name are not empty
        if(userFirstNameTextField.text!.isEmpty || userLastNameTextField.text!.isEmpty)
        {
            var myAlert = UIAlertController(title: "Alert", message: "First Name and Last Name Fields are Required", preferredStyle: UIAlertControllerStyle.Alert);
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction);
            self.presentViewController(myAlert, animated: true, completion: nil);
            
            return
        }
        
        //Set New Values for First and Last Name
        let userFirstName = userFirstNameTextField.text!
        let userLastName = userLastNameTextField.text!
        
        myUser.setObject(userFirstName, forKey: "first_name")
        myUser.setObject(userLastName, forKey: "last_name")
        
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
                var myAlert = UIAlertController(title: "Alert", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                myAlert.addAction(okAction);
                self.presentViewController(myAlert, animated: true, completion: nil);
                
                return
            }
            
            if(success)
            {
                var userMessage = "Profile details successfully updated"
                
                var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        self.opener.loadUserDetails()
                    })
                })
                
                myAlert.addAction(okAction);
                self.presentViewController(myAlert, animated: true, completion: nil)
                return
            }
        }
    }
    
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
