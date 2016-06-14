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
        
        postUpdateButton.isEnabled = false
        postUpdateButton.backgroundColor = .lightGray()
        
        //hide remove button
        removeButton.isHidden = true
        
        //hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(PostUpdateViewController.hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //reset UI
        postImageView.image = UIImage(named: "")
        
        //select image tap
        let picTap = UITapGestureRecognizer(target: self, action: #selector(PostUpdateViewController.selectImage))
        picTap.numberOfTapsRequired = 1
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(picTap)
    }
    
    @IBAction func selectPhotoButtonTapped(_ sender: AnyObject) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
        postImageView.image = info [UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
        
        postUpdateButton.isEnabled = true
        postUpdateButton.backgroundColor = UIColor(red:0.13, green:0.57, blue:1.00, alpha:1.00)
        
        //unhide remove button
        removeButton.isHidden = false
        
    }
    
    //hide keyboard function
    func hideKeyboardTap() {
        self.view.endEditing(true)
    }
    
    //function to call image picker
    func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func postUpdateButtonTapped(_ sender: AnyObject) {
        
    //dismiss editing
        self.view.endEditing(true)
        
        let object = PFObject(className: "UpdateObject")
        
        object["username"] = PFUser.current()!.username
        object["avatar"] = PFUser.current()?.value(forKey: "profile_picture") as! PFFile
        
        if (postCaptionTextView.text!.isEmpty) {
            object["caption"] = " "
        } else{
            object["caption"] = postCaptionTextView.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        let postImage = UIImageJPEGRepresentation(postImageView.image!, 0.5)
        let postImageFile = PFFile(name: "postPicture.jpg", data: postImage!)
        object["postImage"] = postImageFile
        
        object.saveInBackground { (success: Bool, error: NSError?) in
            if (error == nil) {
                self.dismiss(animated: true, completion: nil)
                self.viewDidLoad()
                self.postCaptionTextView.text = ""
                self.postHashtagsTextField.text = ""
                self.postEventObjectTextField.text = ""
                
            } else {
                self.displayMessage("Update Failed to Post. Please try again later.")
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
    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeImageButton(_ sender: AnyObject) {
        self.viewDidLoad()
    }
}
