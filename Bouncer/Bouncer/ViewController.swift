//
//  ViewController.swift
//  Bouncer
//
//  Created by UnciaX on 2015/12/17.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var animator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self.view)
    }()
    
    let bouncerBehavoir = BouncerBehavior()
    
    lazy var block : UIView = {
        let myBlock = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40)))
        myBlock.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        myBlock.backgroundColor = UIColor.blackColor()
        return myBlock
    }()
    
    lazy var motionManager = AppDelegate.montionManager
    
    var animating = true
    var linearVelocity = CGPoint.zero
    
    func animationToggle(sender: UIBarButtonItem){
        if animating {
            linearVelocity = bouncerBehavoir.blockBehavior.linearVelocityForItem(block)
            animator.removeBehavior(bouncerBehavoir)
        }else{
            animator.addBehavior(bouncerBehavoir)
            bouncerBehavoir.blockBehavior.addlinearVelocity(linearVelocity ,item:block)
        }
        animating = !animating
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: animating ? UIBarButtonSystemItem.Pause : UIBarButtonSystemItem.Play, target: self, action: "animationToggle:")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: animating ? UIBarButtonSystemItem.Pause : UIBarButtonSystemItem.Play, target: self, action: "animationToggle:")
        
        
        animator.addBehavior(bouncerBehavoir)
        view.addSubview(block)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        bouncerBehavoir.addBlock(block)
        
        if motionManager.accelerometerAvailable{
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()){(data, error) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                if data != nil {
                    self.bouncerBehavoir.gravity.gravityDirection = CGVector(dx: data!.acceleration.x, dy: -data!.acceleration.y)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        motionManager.stopAccelerometerUpdates()
    }
}

