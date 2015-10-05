//
//  logInViewController.swift
//  FuseIgnite
//
//  Created by Daniel Reilly on 05/10/2015.
//  Copyright © 2015 Fuse Technology. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    let scrollViewWallSegue = "LoginSuccesful"
    let tableViewWallSegue = "LoginSuccesfulTable"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func logInPressed(sender: AnyObject) {
        performSegueWithIdentifier(scrollViewWallSegue, sender: nil)
    }
}