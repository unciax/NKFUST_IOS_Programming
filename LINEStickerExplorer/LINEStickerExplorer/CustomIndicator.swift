//
//  CustomIndicator.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2015/12/31.
//  Copyright © 2015年 UnciaX. All rights reserved.
//


import UIKit

class CustomIndicator: UIView {
    
    var label = UILabel(frame: CGRectZero)
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let frameOfLabel = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        label.frame = frameOfLabel
        label.center = CGPoint(x: bounds.midX, y: bounds.midY)
        label.text = "Loading..."
    }
    
    
    func setup(){
        
        print("\(bounds)")
        backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        contentMode = UIViewContentMode.Redraw
        addSubview(label)
    }
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(frame: CGRect, bgColor: UIColor, labelColor: UIColor){
        self.init(frame: frame)
        backgroundColor = bgColor
        label.textColor = labelColor
    }
    
    
    
}
