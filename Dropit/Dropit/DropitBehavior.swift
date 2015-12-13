//
//  DropitBehavior.swift
//  Dropit
//
//  Created by UnciaX on 2015/12/10.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class DropitBehavior: UIDynamicBehavior {
    let gravity = UIGravityBehavior()
    lazy var collider: UICollisionBehavior = {
        let lazilyCratedCollider = UICollisionBehavior()
        lazilyCratedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCratedCollider
    }()
    lazy var metaBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedMetaBehavior = UIDynamicItemBehavior()
        lazilyCreatedMetaBehavior.allowsRotation = false
        lazilyCreatedMetaBehavior.elasticity = 0.5
        return lazilyCreatedMetaBehavior
    }()

    override init(){
        super.init()
        
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(metaBehavior)
        print("Gravity's (mag, angle) = (\(gravity.magnitude), \(gravity.angle / CGFloat(M_PI))𝛑)")
    }
    
    func addDrop(drop: UIView){
        dynamicAnimator?.referenceView?.addSubview(drop)
        gravity.addItem(drop)
        collider.addItem(drop)
        metaBehavior.addItem(drop)
    }
    
    func removeDrop(drop: UIView){
        collider.removeItem(drop)
        gravity.removeItem(drop)
        metaBehavior.removeItem(drop)
        drop.removeFromSuperview()
    }
}
