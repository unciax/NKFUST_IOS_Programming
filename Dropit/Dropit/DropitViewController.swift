//
//  DropitViewController.swift
//  Dropit
//
//  Created by UnciaX on 2015/12/10.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class DropitViewController: UIViewController, UIDynamicAnimatorDelegate {
    var dropsPerRow = 10
    var dropSize:CGSize {
        let edge = gameView.bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: edge, height: edge)
    }
    lazy var animator:UIDynamicAnimator = {
        let lazilyCreatedAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazilyCreatedAnimator.delegate = self
        return lazilyCreatedAnimator
    }()
    
    var dropitBehavior = DropitBehavior()
    
    @IBOutlet weak var gameView: UIView!
    @IBAction func drop(sender: UITapGestureRecognizer) {
        drop()
    }
    
    func drop(){
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow)*dropSize.width
        
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        
        dropitBehavior.addDrop(dropView)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        animator.addBehavior(dropitBehavior)
                
    }

    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        removeCompletedRow()
    }
    
    func removeCompletedRow(){
        var dropsToRemove = [UIView]()
        var rowIsComplete  = true
        var dropFrame = CGRect(x: 0, y:gameView.frame.maxY, width: dropSize.width, height: dropSize.height)
        
        repeat{
            dropFrame.origin.y -= dropSize.height
            dropFrame.origin.x = 0
            var dropFound = [UIView]()
            for _ in 0 ..< dropsPerRow{
                if let hitView = gameView.hitTest(CGPoint(x: dropFrame.midX, y: dropFrame.midY), withEvent: nil){
                    if hitView.superview == gameView {
                        dropFound.append(hitView)
                    }else{
                        rowIsComplete = false
                    }
                }
                dropFrame.origin.x += dropSize.width
            }
            if rowIsComplete {
                dropsToRemove += dropFound
            }
        } while dropsToRemove.count == 0 && dropFrame.origin.y>0
        
        for drop in dropsToRemove{
            dropitBehavior.removeDrop(drop)
        }
    }
    
}

private extension CGFloat{
    static func random(max:Int)->CGFloat{
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor{
    class var random:UIColor{
        switch arc4random()%6{
        case 0: return UIColor.redColor()
        case 1: return UIColor.orangeColor()
        case 2: return UIColor.yellowColor()
        case 3: return UIColor.greenColor()
        case 4: return UIColor.blueColor()
        case 5: return UIColor.purpleColor()
        default: return UIColor.grayColor()
        }
    }
}

