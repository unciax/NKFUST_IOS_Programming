//
//  StickerListCell.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2015/12/26.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class StickerListCell: UICollectionViewCell {
    
    // MARK: - Property
    
    var stickerID: Int?
    @IBOutlet weak var stickerName: UILabel!
    @IBOutlet weak var stickerImage: UIImageView!
    
    // MARK: - Method
    
    func setProperty(id:Int, name:String, img:NSData){
        stickerID = id
        stickerName.text = name
        stickerImage.image = UIImage(data:img)
    }
    
}
