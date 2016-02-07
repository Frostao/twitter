//
//  TweetsCell.swift
//  Twitter
//
//  Created by Carl Chen on 2/7/16.
//  Copyright © 2016 frostao. All rights reserved.
//

import UIKit

class TweetsCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var repostCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func replyTapped(sender: AnyObject) {
    }
    @IBAction func retweetTapped(sender: AnyObject) {
        
    }
    @IBAction func likeTapped(sender: AnyObject) {
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
