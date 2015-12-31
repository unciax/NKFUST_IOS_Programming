//
//  ShowLargeSticker.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2015/12/31.
//  Copyright © 2015年 UnciaX. All rights reserved.
//


import UIKit

class ShowLargeSticker_OLD: UIView {
    
    var img = UIImageView(frame: CGRectZero)
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let frameOfImage = CGRect(x: 8, y: 8, width: img.image!.size.width, height: img.image!.size.height)
        img.frame = frameOfImage
        
    }
    
    
    func setup(){
        
        print("\(bounds)")
        backgroundColor = UIColor.clearColor()
        
        contentMode = UIViewContentMode.Redraw
        addSubview(img)
    }
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(image: UIImage){
        self.init(frame: CGRect(x: 8, y: 8, width: image.size.width+16, height: image.size.height+16))
        self.img.image = image
    }
    
}
