//
//  PendingFriendCell.swift
//  TickHelp
//
//  Created by Lihui(Luna) Lu on 5/24/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit

class PendingFriendCell: UITableViewCell {
    @IBOutlet weak var userNickname: UILabel!


    @IBOutlet weak var waitingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
