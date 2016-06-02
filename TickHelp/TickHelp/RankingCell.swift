//
//  RankingCell.swift
//  TickHelp
//
//  Created by Lihui(Luna) Lu on 5/25/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit

class RankingCell: UITableViewCell {
    

    @IBOutlet weak var rankNumber: UILabel!
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

