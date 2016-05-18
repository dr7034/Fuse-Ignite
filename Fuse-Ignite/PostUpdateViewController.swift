//
//  PostUpdateViewController.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 11/05/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import Parse
import ParseUI

class PostUpdateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var postCaptionTextView: UITextField!
    @IBOutlet weak var postHashtagsTextField: UITextField!
    @IBOutlet weak var postEventObjectTextField: UITextField!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postUpdateButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postUpdateButton.enabled = false
        postUpdateButton.backgroundColor = .lightGrayColor()
        
        //hide remove button
        removeButton.hidden = true
        
        //hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(PostUpdateViewController.hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //select image tap
        let picTap = UITapGestureRecognizer(target: self, action: #selector(PostUpdateViewController.selectImage))
        picTap.numberOfTapsRequired = 1
        postImageView.userInteractionEnabled = true
        postImageView.addGestureRecognizer(picTap)
        
    }
    
    @IBAction func selectPhotoButtonTapped(sender: AnyObject) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
        postImageView.image = info [UIImagePickerControllerEditedImage] as! UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.postImageView.layer.cornerRadius = self.postImageView.frame.size.width / 2;
        self.postImageView.clipsToBounds = true;
        
        postUpdateButton.enabled = true
        postUpdateButton.backgroundColor = UIColor(red:0.13, green:0.57, blue:1.00, alpha:1.00)
    }
    
    
    //hide keyboard function
    func hideKeyboardTap() {
        self.view.endEditing(true)
    }
    
    //function to call image picker
    func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
    }
    
    
    @IBAction func postUpdateButtonTapped(sender: AnyObject) {
        
    //dismiss editing
        self.view.endEditing(true)
        
        let object = PFObject(className: "UpdateObject")
        
        object["username"] = PFUser.currentUser()!.username
        
        if (postCaptionTextView.text!.isEmpty) {
            object["caption"] = " "
        } else{
            object["caption"] = postCaptionTextView.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        let postImage = UIImageJPEGRepresentation(postImageView.image!, 0.5)
        let postImageFile = PFFile(name: "postPicture.jpg", data: postImage!)
        object["postImage"] = postImageFile
        
        object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if (error == nil) {
                self.displayMessage("Update Posted Successfully to \(self.postEventObjectTextField.text!)")
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.displayMessage("Update Failed to Post. Please try again later.")
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
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var removeImageButton: UIButton!
   
    
}
