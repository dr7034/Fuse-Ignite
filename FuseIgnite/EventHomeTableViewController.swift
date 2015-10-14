//
//  EventHomeTableViewController.swift
//  FuseIgnite
//
//  Created by Daniel Reilly on 14/10/2015.
//  Copyright © 2015 Fuse Technology. All rights reserved.
//

import Foundation
import Parse

class EventHomeTableViewController: PFQueryTableViewController {
    
    // Initialise the PFQueryTable tableview
    override init!(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        
        //Configure the PFQueryTableView
        self.parseClassName = "EventHomeController"
        
    })
    
}