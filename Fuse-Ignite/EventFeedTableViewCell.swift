//
//  EventFeedTableViewCell.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 26/05/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit

class EventFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var timeSincePostLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var postTitleImageView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
