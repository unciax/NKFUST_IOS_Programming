//
//  StickerListCollectionViewController.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2015/12/26.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class StickerListCollectionViewController: UICollectionViewController {

    // MARK: - Controler
    
    @IBOutlet var myCollectionView: UICollectionView!
    var core:DataCore!
    var alert:UIAlertController?
    var isFirst:Bool = true
    var indicator = CustomIndicator(frame: CGRectZero)
    var isLoaded = false
    var alphaUpOrDown = true
    var timer:NSTimer?
    
    // MARK: - View Event
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        alert = nil
        var isErrorOccurred:Bool = false
        
        core = DataCore()
        
        indicator = CustomIndicator(frame: CGRect(x: myCollectionView.frame.width/2-50, y: myCollectionView.frame.height/2-12, width: 100, height: 30))
        view.addSubview(indicator)
        
        indicator.alpha=0.0
        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "fire:", userInfo: nil, repeats: true)
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
            
            
            
            isErrorOccurred = self.core.loadData()
            
            if isErrorOccurred {
                self.alert = UIAlertController(title: "", message: "無法連線至伺服器，請稍候再試", preferredStyle: UIAlertControllerStyle.Alert)
                self.alert!.addAction(UIAlertAction(title: "好", style:UIAlertActionStyle.Default, handler:nil))
            }
            self.isLoaded = true
            
            
            dispatch_async(dispatch_get_main_queue()){
                self.indicator.removeFromSuperview()
                self.myCollectionView.reloadData()
                if self.alert != nil {
                    print("Show Alert")
                    self.presentViewController(self.alert!, animated: true, completion: nil)
                    self.alert = nil
                }
            }
        }//TODO : replace nil to show last download data

    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Show alert if exist.
        
        
    }

    func fire(timer: NSTimer) {
        // Up : true - Down : false
        if isLoaded {
            timer.invalidate()
        }else{
            if indicator.alpha<=0 { alphaUpOrDown=true }
            else if indicator.alpha>=1 { alphaUpOrDown=false }
            indicator.alpha = alphaUpOrDown ? indicator.alpha+0.2 : indicator.alpha-0.2
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        var sSet = stickerSet()
        if (segue.identifier == "showSetInfo"){
            if let indexPath = myCollectionView?.indexPathsForSelectedItems(){
                for path in indexPath{
                    sSet = core.setArray[path.row]
                }
            }
            let VC = segue.destinationViewController as! StickerViewController
            VC.sSet = sSet
            VC.core = core
            VC.title = "檢視貼圖：\(sSet.setName)"
            
        }

    }
    

    // MARK: UICollectionViewDataSource


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (core?.setArray.count)!
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! StickerListCell
        let sSet = core!.setArray[indexPath.row]
        cell.setProperty(sSet.setID, name: sSet.setName, img: sSet.image!)
    
        return cell
    }

}
