//
//  SignUpViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 12/01/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var userEmailAddresssTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userPasswordRepeatTextField: UITextField!
    @IBOutlet weak var userFullNameTextField: UITextField!
    @IBOutlet weak var userJobTitleTextField: UITextField!
    @IBOutlet weak var userCompanyNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userWebPageTextField: UITextField!
    @IBOutlet weak var userInterestsTextField: UITextField!
    @IBOutlet weak var userShowDataSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    override func viewDidLayoutSubviews() {
        self.edgesForExtendedLayout = UIRectEdge()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectProfilePhotoButtonTapped(_ sender: AnyObject) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
        profilePhotoImageView.image = info [UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
        
        self.profilePhotoImageView.layer.cornerRadius = self.profilePhotoImageView.frame.size.width / 2;
        self.profilePhotoImageView.clipsToBounds = true;
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(_ sender: AnyObject) {
        
        let userName = usernameTextField.text
        let userPassword = userPasswordTextField.text
        let userPasswordRepeat = userPasswordRepeatTextField.text
        let userFullName = userFullNameTextField.text
        let userJobTitle = userJobTitleTextField.text
        let userCompanyName = userCompanyNameTextField.text
        
      if(userName!.isEmpty || userPassword!.isEmpty || userPasswordRepeat!.isEmpty || userFullName!.isEmpty)
      {
            let userMessage = "All fields are required to fill in"
            self.displayMessage(userMessage)
        
        }
        
        if (!validateEmail(userEmailAddresssTextField.text!)) {
            displayMessage("Invalid Email")
            return
        }
        
        if (!validateWebPage(userWebPageTextField.text!)) {
            displayMessage("Invalid Web Page. Please enter web pages in the following format: http://fuseignite.co")

            return
        }
        
        if(userPassword != userPasswordRepeat)
        {
            let userMessage = "Passwords do not match, please try again."
            self.displayMessage(userMessage)
        }
        
        let myUser:PFUser = PFUser()
        myUser.username = userName
        myUser.password = userPassword
        myUser.email = userName
        myUser.setObject(userFullName!, forKey: "fullName")
        myUser.setObject(userJobTitle!, forKey: "jobTitle")
        myUser.setObject(userCompanyName!, forKey: "companyName")
        
        let profileImageData = UIImageJPEGRepresentation(profilePhotoImageView.image!, 1)
        
        if(profileImageData != nil)
        {
            //Create PFFile Object to send to parse cloud service
            
            if(profileImageData != nil)
            {
            let profileImageFile = PFFile(data: profileImageData!)
                myUser.setObject(profileImageFile, forKey: "profile_picture")
            }
            
        
            myUser.signUpInBackground {(success: Bool, error: NSError?) -> Void in
                
                var userMessage = "Registration was successful. Thank you!"
                
                if(!success)
                {
                    userMessage = error!.localizedDescription
                }
                self.displayMessage(userMessage)
            }
            
        }
        
    }
    
    func validateEmail(_ email:String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Z0-9a-z._]+{2}\\.[AZa-z]{2}"
        let range = email.range(of: regex, options: .regularExpressionSearch)
        let result = range != nil ? true:false
        return result
    }
    
    func validateWebPage(_ webpage:String) -> Bool {
        let regex = "http://+[A-Z0-9a-z.%+-]+.[A-Za-z]{2}"
        let range = webpage.range(of: regex, options: .regularExpressionSearch)
        let result = range != nil ? true:false
        return result
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
