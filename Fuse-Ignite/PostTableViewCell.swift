//
//  PostTableViewCell.swift
//  Fuse-Ignite
//
//  Created by Daniel Reilly on 25/05/2016.
//  Copyright © 2016 Fuse Technology. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!

    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var uuidHiddenLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
