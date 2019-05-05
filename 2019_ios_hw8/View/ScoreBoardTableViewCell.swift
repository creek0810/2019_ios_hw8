//
//  ScoreBoardTableViewCell.swift
//  2019_ios_hw8
//
//  Created by 王心妤 on 2019/5/4.
//  Copyright © 2019年 river. All rights reserved.
//

import UIKit

class ScoreBoardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var costTime: UILabel!
    @IBOutlet weak var rank: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
