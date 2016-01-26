//
//  EventFeedTableViewCell.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 25/01/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit

class EventFeedTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}