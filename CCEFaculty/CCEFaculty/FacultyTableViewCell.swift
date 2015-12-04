//
//  FacultyTableViewCell.swift
//  CCEFaculty
//
//  Created by UnciaX on 2015/12/3.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class FacultyTableViewCell: UITableViewCell {

    @IBOutlet weak var selfimage: UIImageView!
    @IBOutlet weak var teacherName: UILabel!    
    @IBOutlet weak var teacherEdu: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selfimage.layer.cornerRadius = 5
        selfimage.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
