//
//  EventHomeController.swift
//  FuseIgnite
//
//  Created by Daniel Reilly on 07/10/2015.
//  Copyright © 2015 Fuse Technology. All rights reserved.
//

import Foundation
import Parse
import UIKit

class EventFeedViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    if self.revealViewController() != nil {
    menuButton.target = self.revealViewController()
    menuButton.action = "revealToggle:"
    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
}
}