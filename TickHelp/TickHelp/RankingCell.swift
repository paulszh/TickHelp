//
//  RankingCell.swift
//  TickHelp
//
//  Created by Lihui(Luna) Lu on 5/25/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit
import FoldingCell

class RankingCell: FoldingCell {
    
    @IBOutlet weak var userBigNickname: UILabel!
    
    @IBOutlet weak var userBigUserdescription: UILabel!
    @IBOutlet weak var userBigUsername: UILabel!
    @IBOutlet weak var userNickname: UILabel!
    override func awakeFromNib() {
        
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        
        super.awakeFromNib()
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}

