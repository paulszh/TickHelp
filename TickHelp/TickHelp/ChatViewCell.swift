//
//  ChatViewCell.swift
//  TickHelp
//
//  Created by Hongda Xiao on 5/6/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit

class ChatViewCell: UITableViewCell {
  //  @IBOutlet weak var messageLabel: UILabel! = UILabel()
   // @IBOutlet weak var nameLabel: UILabel! = UILabel()
    
    @IBOutlet weak var messageLabel: UILabel! = UILabel()
    @IBOutlet weak var nameLabel: UILabel! = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    required init? (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
