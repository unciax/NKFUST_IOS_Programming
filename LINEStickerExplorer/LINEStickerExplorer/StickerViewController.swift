//
//  StickerViewController.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2015/12/26.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class StickerViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UIPopoverPresentationControllerDelegate  {
    
    var sSet = stickerSet()
    var core = DataCore()
    var count:Int = 0
    var alert:UIAlertController?
    var isReady:Bool = false
    var index:Int = 0
    var indicator = CustomIndicator(frame: CGRectZero)
    var isLoaded = false
    var alphaUpOrDown = true
    var timer:NSTimer?
    
    //MARK: - IBOutlet
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var stickerImage: UIImageView!
    @IBOutlet weak var stickerAuthor: UILabel!
    @IBOutlet weak var stickerTitle: UILabel!
    @IBOutlet weak var stickerPrice: UILabel!
    @IBOutlet weak var lblValidDays: UILabel!
    
    @IBAction func buySticker(sender: UIButton) {
        let storeURL = NSURL(string: "https://store.line.me/stickershop/product/\(sSet.setID)/zh-Hant")!
         UIApplication.sharedApplication().openURL(storeURL)
    }
    
    //MARK: - UICollectionView
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: StickerObjectCell = collectionView.dequeueReusableCellWithReuseIdentifier("stickerCell", forIndexPath: indexPath) as! StickerObjectCell
        let sArrayItem = core.sArray[indexPath.row]
        cell.setProperty(sArrayItem.sID, img:sArrayItem.sImage!)
        //print("ID: \(cell.sID) \(cell.sImage.frame.height)")
        count++
        return cell
    }   //build cell
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isReady ? core.sArray.count : 0
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let sArrayItem = core.sArray[indexPath.row]
        let detailController: ShowLargeStickerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("showLargeSticker") as! ShowLargeStickerViewController
        detailController.st = sArrayItem
        detailController.modalPresentationStyle = .Popover
        let cell = myCollectionView.cellForItemAtIndexPath(indexPath)
        let popoverView = detailController.popoverPresentationController
        detailController.preferredContentSize = CGSize(width: detailController.st.image!.size.width+16, height: detailController.st.image!.size.height+16)
        popoverView?.delegate=self
        popoverView?.sourceView = cell
        popoverView?.permittedArrowDirections = .Any
        
        popoverView?.sourceRect = cell!.bounds
        presentViewController(detailController, animated: true, completion: nil)

    }
    
    
    //MARK: - Other
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        index = self.core.setArray.indexOf({$0.setID == self.sSet.setID})!
        stickerImage.image = UIImage(data:sSet.image!)
        stickerAuthor.text = sSet.setAuthor
        stickerTitle.text = sSet.setName
        stickerPrice.text = "貼圖價格：代幣 \(sSet.price)"
        if(sSet.validDays == 0){
            lblValidDays.text = "有效期限：永久"
        }else{
            lblValidDays.text = "有效期限：\(sSet.validDays)"
        }
        
        var isErrorOccurred:Bool = false
        print("view frame : \(view.frame) cv frame: \(myCollectionView.frame)")
        indicator = CustomIndicator(frame: CGRect(x: myCollectionView.frame.width/2-50, y: myCollectionView.frame.height/2-15, width: 100, height: 30))
        myCollectionView.addSubview(indicator)
        
        indicator.alpha=0.0
        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "fire:", userInfo: nil, repeats: true)
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
            
            // Clear all!
            self.core.sArray = [sticker]()
            self.count = 0
            
            self.core.sArray = self.core.db.stickerQuery(self.sSet.setID)
            
            if self.core.sArray.count == 0 {
                isErrorOccurred = !self.core.getStickerInfo(self.sSet.setID)
            }


           for sArrayItem in self.core.sArray{
               sArrayItem.loadImage()
            }
            
            if isErrorOccurred {
                self.alert = UIAlertController(title: "", message: "無法連線至伺服器，請稍候再試", preferredStyle: UIAlertControllerStyle.Alert)
                self.alert!.addAction(UIAlertAction(title: "好", style:UIAlertActionStyle.Default, handler:nil))
            }
            self.isLoaded = true
            
            dispatch_async(dispatch_get_main_queue()){
                self.indicator.removeFromSuperview()
                self.isReady = true
                self.myCollectionView.reloadData()
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Show alert if exist.
        if alert != nil {
            self.presentViewController(alert!, animated: true, completion: nil)
            alert = nil
        }
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            super.prepareForSegue(segue, sender: sender)
            var st = sticker()
            if (segue.identifier == "showLargeSticker"){
        if let indexPath = myCollectionView?.indexPathsForSelectedItems(){
                for path in indexPath{
                st = core.sArray[path.row]
                }
        }
        let VC = segue.destinationViewController as! ShowLargeStickerViewController
        VC.st = st
        
            }
    }
    
    func adaptivePresentationStyleForPresentationController(
                controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}

