//
//  chatTableViewCell.swift
//  TickHelp
//
//  Created by Ariel on 4/12/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit

class chatTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel! = UILabel()
    
    @IBOutlet weak var messenge: UILabel! = UILabel()
    
    
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
