//
//  MainViewController.swift
//  Dropit
//
//  Created by UnciaX on 2015/12/16.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIDynamicAnimatorDelegate {
    @IBOutlet weak var gameView: BezierPathsView!
    
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
    var sur_timer:NSTimer = NSTimer()
    
    func drop(){
        var frame = CGRect(origin: CGPoint(x:0, y:2),size: dropSize)
        let offset = CGFloat.random(dropsPerRow)
        frame.origin.x = offset*dropSize.width
        
        print("Row : \(Int(offset)) -> ")
    
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        
        dropitBehavior.addDrop(dropView)
        print("\(dropView.frame.origin.y)")
        
        
        
    }
    
    func checkRow(timer: NSTimer){
        drop()
        removeCompletedRow()
    }
    
    func removeCompletedRow(){
        var dropsToRemove = [UIView]()
        var rowIsComplete  = true
        var dropFrame = CGRect(x: 0, y:gameView.frame.maxY, width: dropSize.width, height: dropSize.height)
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
        for drop in dropsToRemove{
            dropitBehavior.removeDrop(drop)
        }
    }
    
    override func viewDidAppear(animated: Bool){
        sur_timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: "checkRow:", userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator.addBehavior(dropitBehavior)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(segue: UIStoryboardSegue){
        
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        sur_timer.invalidate()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - extension

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

