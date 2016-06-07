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

var userInterestsArray = [String]()

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userFullNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userPasswordRepeatTextField: UITextField!
    @IBOutlet weak var userCompanyNameTextField: UITextField!
    @IBOutlet weak var userJobTitleTextField: UITextField!
    @IBOutlet weak var userInterestsTextField: UITextField!
    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userIntroductionTextView: UITextView!
    @IBOutlet weak var userNetworkingObjectivesTextView: UITextView!
    @IBOutlet weak var userTelNumberTextField: UITextField!
    @IBOutlet weak var userWebAddressTextField: UITextField!
    @IBOutlet weak var userTwitterHandleTextField: UITextField!
    @IBOutlet weak var userEventObjectivesTextField: UITextField!
    @IBOutlet weak var userMotivationsTextField: UITextField!
    @IBOutlet weak var userConversationTopicsTextField: UITextField!
    
    var opener: LeftSideViewController!
    
    var currentObject : PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Load User Details
        userInterestsArray.removeAll(keepCapacity: false)
        
        if let object = PFUser.currentUser() {
            userFullNameTextField.text = object["fullName"] as? String
            userCompanyNameTextField.text = object["companyName"] as? String
            userJobTitleTextField.text = object["jobTitle"] as? String
            userEmailAddressTextField.text = object["email"] as? String
            userTelNumberTextField.text = object["telNumber"] as? String
            userWebAddressTextField.text = object["webPage"] as? String
            userTwitterHandleTextField.text = object["twitterHandle"] as? String
            
            //populate text areas 
            userIntroductionTextView.text = object["userBio"] as? String
            userNetworkingObjectivesTextView.text = object["networkingObjectives"] as? String
            
            //populate user interests
            let userInterests = object["userInterests"] as? NSArray
            let userInterestsArray = userInterests?.componentsJoinedByString(", ")
            userInterestsTextField.text = userInterestsArray
            
            //populate eventObjectives
            let eventObjectives = object["eventObjectives"] as? NSArray
            let eventObjectivesArray = eventObjectives?.componentsJoinedByString(", ")
            userEventObjectivesTextField.text = eventObjectivesArray
            
            //populate user motivations
            let userMotivations = object["userMotivations"] as? NSArray
            let userMotivationsArray = userMotivations?.componentsJoinedByString(", ")
            userMotivationsTextField.text = userMotivationsArray
            
            //populate conversation Topics
            let conversationTopics = object["conversationTopics"] as? NSArray
            let conversationTopicsArray = conversationTopics?.componentsJoinedByString(", ")
            userConversationTopicsTextField.text = conversationTopicsArray
            
            }
        
        currentObject?.fetchInBackgroundWithBlock({ (object, error) in
            
            var userInterests = self.userInterestsTextField.text
            userInterests = object!["userInterests"] as? String
            userInterests?.componentsSeparatedByString(", ")
        })
        
        
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
        let userObject:PFUser = PFUser.currentUser()!
        
        //Get profile image
        let profileImageData = UIImageJPEGRepresentation(profilePictureImageView.image!, 1)
        
        //Check if all fields are empty
        if(userPasswordTextField.text!.isEmpty && userFullNameTextField.text!.isEmpty && (profileImageData == nil))
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
        
        //Check if full name is not empty
        if(userFullNameTextField.text!.isEmpty)
        {
            let userMessage = "Name Field is Required"
            self.displayMessage(userMessage)
        }
        
        //Set New Values for Full Name
        let userFullName = userFullNameTextField.text!
        userObject.setObject(userFullName, forKey: "fullName")
        
        // Set New Password
        if(userPasswordTextField.text != nil)
        {
            let userPassword = userPasswordTextField.text
            userObject.password = userPassword
        }
        
        //set user bio
        let userBio = userIntroductionTextView.text!
        //FIELD NAME MAY NOT BE CORRECT
        userObject.setObject(userBio, forKey: "userBio")
        
        //set user networking objectives
        let networkingObjectives = userNetworkingObjectivesTextView.text!
        userObject.setObject(networkingObjectives, forKey: "networkingObjectives")
        
        //set user email
        let userEmail = userEmailAddressTextField.text!
        userObject.setObject(userEmail, forKey: "email")
        
        //set telephone number
        let userTelNumber = userTelNumberTextField.text!
        userObject.setObject(userTelNumber, forKey: "TelNumber")
        
        //set web address
        let webPage = userWebAddressTextField.text!
        userObject.setObject(webPage, forKey: "webPage")
        
        //set Twitter handle
        let twitterHandle = userTwitterHandleTextField.text!
        userObject.setObject(twitterHandle, forKey: "twitterHandle")
        
        //set user interets
        let userInterests = userInterestsTextField.text!
        userObject.setObject("[" + userInterests + "]", forKey: "userInterests")
        
        //set event objectives
        let eventObjectives = userEventObjectivesTextField.text!
        userObject.setObject("[" + eventObjectives + "]", forKey: "eventObjectives")
        
        //set motivations
        let motivations = userMotivationsTextField.text!
        userObject.setObject("[" + motivations + "]", forKey: "motivations")
        
        //set conversation Topics
        let conversationTopics = userConversationTopicsTextField.text!
        userObject.setObject("[" + conversationTopics + "]", forKey: "conversationTopics")
        
        //set binary contact info sharing request
        
        
        //Set Profile Picture
        if(profileImageData != nil)
        {
            let profileFileObject = PFFile(data: profileImageData!)
            userObject.setObject(profileFileObject, forKey: "profile_picture")
        }
        
        //Display Activity Indicator
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = "Updating Info."
        loadingNotification.detailsLabelText = "Please Wait..."
        
        //Save in Data in Background with Block
        
        userObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
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