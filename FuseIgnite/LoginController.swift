//
//  UsersController.swift
//  FuseIgnite
//
//  Created by Daniel Reilly on 02/10/2015.
//  Copyright © 2015 Fuse Technology. All rights reserved.
//

import Foundation
import Parse
import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var UsernameInput: UITextField!
    @IBOutlet weak var PasswordInput: UITextField!
    @IBOutlet weak var SavePasswordSwitch: UISwitch!
    
    let LoginSuccessSegue = "LoginSuccessfulSegue"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let user = PFUser.currentUser() {
            if user.isAuthenticated() {
                self.performSegueWithIdentifier(LoginSuccessSegue, sender: nil)
            }
        }
    }
    
    
      // MARK: - Actions
    @IBAction func SignInButton(sender: UIButton) {
        PFUser.logInWithUsernameInBackground(UsernameInput.text!, password: PasswordInput.text!) { user, error in
            if user != nil {
                self.performSegueWithIdentifier(self.LoginSuccessSegue, sender: nil)
            } else if let error = error {
                print(error)
            }
        }
    }
}