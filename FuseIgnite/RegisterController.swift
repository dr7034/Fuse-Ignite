//
//  RegisterController.swift
//  FuseIgnite
//
//  Created by Daniel Reilly on 07/10/2015.
//  Copyright © 2015 Fuse Technology. All rights reserved.
//

import Foundation
import UIKit
import Parse

class RegisterController: UIViewController {
    
    @IBOutlet weak var RegisterNameInput: UITextField!
    @IBOutlet weak var RegisterEmailInput: UITextField!
    @IBOutlet weak var RegisterUsernameInput: UITextField!
    
    @IBOutlet weak var RegisterPasswordInput: UITextField!
    
    let LoginSuccessSegue = "LoginSuccessfulSegue"
    
    /**
    * Called when 'return' key pressed. return NO to ignore.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
    * Called when the user click on the view (outside the UITextField).
    */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func RegisterButton(sender: AnyObject) {
        //1
        let user = PFUser()
        
        //2
        user.username = RegisterNameInput.text
        user.password = RegisterPasswordInput.text
        user.email = RegisterEmailInput.text
        //    user.name = RegisterNameInput.text
        
        //3
        user.signUpInBackgroundWithBlock { succeeded, error in
            if (succeeded) {
                //The registration was successful, go to the wall
                self.performSegueWithIdentifier(self.LoginSuccessSegue, sender: nil)
            } else if let error = error {
                //Something bad has occurred
                print(error)
            }
        }

    }
    
    
}