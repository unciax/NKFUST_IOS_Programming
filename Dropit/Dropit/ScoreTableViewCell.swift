//
//  ScoreTableViewCell.swift
//  Dropit
//
//  Created by UnciaX on 2015/12/17.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var lblMode: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
