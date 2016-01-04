//
//  DropitViewController.swift
//  Dropit
//
//  Created by UnciaX on 2015/12/10.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class DropitViewController: UIViewController, UIDynamicAnimatorDelegate {
 
    //MARK: - 分數統計
    
    var score = 0
    var comboCount = 0
    var timeCount = 0
    var additionCount = 0
    var scorePerRow = 10.0
    var additionPerFiveCombo = 0.5
    var comboStillTime = 3 // when complete row in ? second will not broke combo
    var socrePerSecond = 10
    var sr = ScoreRecord ()
    var st = NSDate()
    
    //MARK: - 其他
    
    // 每一行,列可存在多少drop
    var dropsPerRow = 10
    var dropSize:CGSize {
        let edge = gameView.bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: edge, height: edge)
    }
    var dropPerCol:Int{
        let float = gameView.bounds.size.height / CGFloat(dropSize.height)
        return Int(round(float))
    }
    var dropPerRowCount:[Int] = [Int](count: 10, repeatedValue: 0)
    
    lazy var animator:UIDynamicAnimator = {
        let lazilyCreatedAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazilyCreatedAnimator.delegate = self
        return lazilyCreatedAnimator
    }()
     var attachment: UIAttachmentBehavior? {
        willSet {
            if attachment != nil {
                animator.removeBehavior(attachment!)
            }
            gameView.setPath(nil, named: PathNames.Attachment)
        }
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment!)
                attachment?.action = { [unowned self] in
                    if let attachedView = self.attachment?.items.first as? UIView {
                        let path = UIBezierPath()
                        path.moveToPoint(self.attachment!.anchorPoint)
                        path.addLineToPoint(attachedView.center)
                        self.gameView.setPath(path, named: PathNames.Attachment)
                    }
                }
            }
        }
    }
    var dropitBehavior = DropitBehavior()
    var timer:NSTimer = NSTimer()
    var sur_timer:NSTimer = NSTimer()
    
    var lastDroppedView: UIView?
    
    

    
    
    
    var catchView:UIView?
    var isEnterGameOver:Bool = false
    

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    @IBOutlet weak var gameView: BezierPathsView!
    @IBOutlet weak var lblScore: UILabel!

    
    
    
    @IBAction func restartBtn(sender: UIButton) {
        // Restart Game
        timer.invalidate()
        sur_timer.invalidate()
        

        let alert = UIAlertController(title: "Restart Game?", message: "Score will be CLEARED. Sure to restart?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Back", style: .Cancel)
            {(action: UIAlertAction) -> Void in
                self.timer = NSTimer.scheduledTimerWithTimeInterval(0.8,
                    target: self, selector: "checkRow:",
                    userInfo: nil,
                    repeats: true
                )
                if self.GameModeSelector.selectedSegmentIndex == 1{
                    self.sur_timer = NSTimer.scheduledTimerWithTimeInterval(0.75, target: self, selector: "autoDrop:", userInfo: nil, repeats: true)
                }
            })
        alert.addAction(UIAlertAction(title: "Sure", style: .Default)
            {(action: UIAlertAction) -> Void in
                self.restartGame()
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }    
    
    @IBAction func drop(sender: UITapGestureRecognizer) {
        drop()
    }
    
    func drop(){
        var frame = CGRect(origin: CGPoint(x:0, y:2),size: dropSize)
        let offset = CGFloat.random(dropsPerRow)
        frame.origin.x = offset*dropSize.width
        dropPerRowCount[Int(offset)]+=Int(dropSize.height)
        //print("Row : \(Int(offset)) -> \(dropPerRowCount[Int(offset)])  Per Column : \(dropPerCol)")
        
        
        
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        lastDroppedView = dropView
        dropitBehavior.addDrop(dropView)
        print("\(dropView.frame.origin.y)")
        
        isGameOver()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        animator.addBehavior(dropitBehavior)
        lblScore.text = "0"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.8,
            target: self, selector: "checkRow:",
            userInfo: nil,
            repeats: true
        )
        print("\(dropSize.width)")
    }
    

    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        //removeCompletedRow()
    }
    
    func checkRow(timer: NSTimer){
        removeCompletedRow()
        if GameModeSelector.selectedSegmentIndex == 1 {
            score += socrePerSecond
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /*
        let barrierSize = dropSize
        let barrierOrigin = CGPoint(x: gameView.bounds.midX-barrierSize.width/2, y: gameView.bounds.midY-barrierSize.height/2)
        let path = UIBezierPath(ovalInRect: CGRect(origin: barrierOrigin, size: barrierSize))
        dropitBehavior.addBarrier(path, named: PathNames.MiddleBarrier)
        gameView.setPath(path, named: PathNames.MiddleBarrier)
        */
    }
    
    
    func removeCompletedRow(){
        var dropsToRemove = [UIView]()
        var rowIsComplete  = true
        var dropFrame = CGRect(x: 0, y:gameView.frame.maxY, width: dropSize.width, height: dropSize.height)
        timeCount++
        var dropFound = [UIView]()
        repeat{
            
            dropFrame.origin.y -= dropSize.height
            dropFrame.origin.x = 0
            for _ in 0 ..< dropsPerRow{
                if let hitView = gameView.hitTest(CGPoint(x: dropFrame.midX, y: dropFrame.midY), withEvent: nil){
                    if hitView.superview == gameView {
                        dropFound.append(hitView)
                        rowIsComplete  = true
                    }else{
                        rowIsComplete = false
                        dropFound = [UIView]()
                        break
                    }
                }
                dropFrame.origin.x += dropSize.width
            }
        
            if rowIsComplete {
                dropsToRemove += dropFound
                for i in 0 ..< dropsPerRow{
                    dropPerRowCount[i] -= Int(dropSize.height)
                }
                timeCount=0
                additionCount = comboCount>0 ? (comboCount-(comboCount%5))/5 : 0
                score = score + Int(round(scorePerRow * (1.0 + Double(additionCount) * additionPerFiveCombo)))
                comboCount++
            
            }else{
                if(timeCount > comboStillTime){
                    comboCount = 0
                    timeCount = 0
                }
                
            }
            //print("Remove:\(dropsToRemove.count)")
            //	print("dropFrame origin \(dropFrame.origin.x) \(dropFrame.origin.y)")
        }while dropsToRemove.count == 0 && dropFrame.origin.y > 0
        //print("COMBO \(comboCount) timeCount = \(timeCount)")
        lblScore.text = "\(score)"
        for drop in dropsToRemove{
            dropitBehavior.removeDrop(drop)
        }
    }

    
    @IBOutlet weak var GameModeSelector: UISegmentedControl!
    @IBAction func GameModeSelect(sender: UISegmentedControl) {
        if score != 0 {
            let alert = UIAlertController(title: "NOTICE", message: "Change game mode will start NEW game. Sure to do?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Back", style: .Cancel)
                {(action: UIAlertAction) -> Void in})
            alert.addAction(UIAlertAction(title: "Sure", style: .Default)
                {(action: UIAlertAction) -> Void in
                    self.restartGame()
                })
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            restartGame()
        }
        
    }
    
    
    //MARK: - 據說這樣可以歸類
    
    func isGameOver(){
        var colIsComplete  = false
        /*
        var dropFrame = CGRect(x: 0, y:gameView.frame.maxY, width: dropSize.width, height: dropSize.height)
        repeat{
            dropFrame.origin.y -= dropSize.height
        }while dropFrame.origin.y > 0
        dropFrame.origin.y += dropSize.height
        dropFrame.origin.x = 0

        for _ in 0 ..< dropsPerRow {
            if let hitView = gameView.hitTest(CGPoint(x: dropFrame.midX, y: -1), withEvent: nil){
                if hitView.superview == gameView {
                    colIsComplete = true
                }else{
                    colIsComplete = false
                }
            }
            dropFrame.origin.x += dropSize.width
        }
        
        for i in 0 ..< dropsPerRow{
            if dropPerRowCount[i] >= dropPerCol*Int(dropSize.height){
                print("Row \(i) Count : \(dropPerRowCount[i]) dropPerCol : \(dropPerCol)")
                colIsComplete = true
                break
            }
        }
        
        
        if(catchView != nil){
            isEnterGameOver=true
        }else{
            isEnterGameOver=false
        }
        for sub in gameView.subviews{
            if(sub.frame.origin.y < 0) {
                print("\(sub.frame.origin.y)")
                catchView = sub
                colIsComplete = true
                break
            }else{
                catchView = nil
            }
        }
        */
        
        var gameViewupperboundRect = CGRect(x: 0, y: 0, width: dropSize.width, height: dropSize.height)
        gameViewupperboundRect.origin.x = 0
        for _ in 0 ..< dropsPerRow{
            if let hitView = gameView.hitTest(CGPoint(x: gameViewupperboundRect.midX, y: 0), withEvent: nil){
                if hitView.superview == gameView{
                    colIsComplete = true
                }
            }
            gameViewupperboundRect.origin.x += gameViewupperboundRect.size.width
        }
        if colIsComplete {
            timer.invalidate()
            sur_timer.invalidate()
            showGameOver()
        }
    }
    
    func showGameOver(){
        print("Enter GameOver")
        var alert:UIAlertController
        if savedScore() {
            // broke record
            alert = UIAlertController(title: "Game Over!", message: "Congratulation, you BROKE HIGHEST SCORE.\n Your score is \(score) ", preferredStyle: UIAlertControllerStyle.Alert)
        }else{
            alert = UIAlertController(title: "Game Over!", message: "Your score is \(score)", preferredStyle: UIAlertControllerStyle.Alert)
        }
        
        alert.addAction(UIAlertAction(title: "Back", style:  .Cancel)
            {(action: UIAlertAction) -> Void in
                self.performSegueWithIdentifier("GoBack Unwind Segue", sender: nil)
            })

        alert.addAction(UIAlertAction(title: "PlayAgain", style: .Default)
            {(action: UIAlertAction) -> Void in
                self.restartGame()
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func restartGame(){
        timer.invalidate()
        sur_timer.invalidate()
        attachment = nil
        for sub in gameView.subviews{
            dropitBehavior.removeDrop(sub)
        }
        dropPerRowCount = [Int](count: 10, repeatedValue: 0)
        score = 0
        comboCount = 0
        lblScore.text = "\(score)"
        catchView = nil
        isEnterGameOver = false
        timer = NSTimer.scheduledTimerWithTimeInterval(0.8,
            target: self, selector: "checkRow:",
            userInfo: nil,
            repeats: true
        )
        if GameModeSelector.selectedSegmentIndex == 1{
            sur_timer = NSTimer.scheduledTimerWithTimeInterval(0.75, target: self, selector: "autoDrop:", userInfo: nil, repeats: true)
        }
        st = NSDate()
    }
    
    func autoDrop(timer: NSTimer){
        drop()
    }
    
    
    @IBAction func grabDrop(sender: UIPanGestureRecognizer) {
        let gesturePoint = sender.locationInView(gameView)
        
        switch sender.state {
        case .Began:
            if let viewToAttachTo = lastDroppedView {
                attachment = UIAttachmentBehavior(item: viewToAttachTo, attachedToAnchor: gesturePoint)
                lastDroppedView = nil
            }
        case .Changed:
            attachment?.anchorPoint = gesturePoint
        case .Ended:
            attachment = nil
        default: break
        }

    }

    struct PathNames {
        static let MiddleBarrier = "Middle Barrier"
        static let Attachment = "Attachment"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoBack Unwind Segue"{
            if let _ = segue.destinationViewController  as? MainViewController{
                print("Unwind")
                timer.invalidate()
            }
        }
    }
    
    func savedScore() -> Bool{
        let isBroke = sr.createANewRecord(score, date: NSDate(), mode: GameModeSelector.selectedSegmentIndex, duration: NSDate().timeIntervalSinceDate(st))
        
        return isBroke
    }

    
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

