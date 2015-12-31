//
//  StickerObjectCell.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2015/12/26.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class StickerObjectCell: UICollectionViewCell {
    
    // MARK: - Property
    var sID:Int?
    @IBOutlet weak var sImage: UIImageView!
    
    // MARK: - Method
    
    func setProperty(id:Int, img:NSData){
        sID = id
        
        sImage.image = UIImage(data:img)
        sImage.sizeThatFits(CGSize(width:sImage.frame.width, height: sImage.frame.height))
  
        //sImage.sizeThatFits(CGSize(width: 34, height: 34))
        //print("frame: \(sImage.frame) bounds: \(sImage.bounds)")
    }
    
    
}
