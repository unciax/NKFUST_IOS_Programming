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
    @IBOutlet var tap: UITapGestureRecognizer!
    
    @IBAction func buySticker(sender: UIButton) {
        let storeURL = NSURL(string: "https://store.line.me/stickershop/product/\(sSet.setID)/zh-Hant")!
         UIApplication.sharedApplication().openURL(storeURL)
    }
    
    //MARK: - UICollectionView
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: StickerObjectCell = collectionView.dequeueReusableCellWithReuseIdentifier("stickerCell", forIndexPath: indexPath) as! StickerObjectCell
        let sArrayItem = core.sArray[indexPath.row]
        cell.setProperty(sArrayItem.sID, img:sArrayItem.sImage!)
        /*
        if cell.sImage.animationImages != nil {
            cell.sImage.animationDuration = 0.5
            cell.sImage.startAnimating()
        }*/
        //print("ID: \(cell.sID) \(cell.sImage.frame.height)")
        count++
        return cell
    }   //build cell
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("BuildCell")
        return isReady ? core.sArray.count : 0
        //return isReady ? 1 : 0
        
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
         //let Cell = cell as!StickerObjectCell
        //print(Cell.sImage.bounds)
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
        if (cell!.frame.maxY>140){
            popoverView?.permittedArrowDirections = .Down
            popoverView?.sourceRect = CGRect(x: cell!.bounds.width/2,y: 0,width: 0,height: 0)
        }else{
            popoverView?.permittedArrowDirections = .Up
            popoverView?.sourceRect = CGRect(x: cell!.bounds.width/2,y: cell!.bounds.height,width: 0,height: 0)
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                controller: UIPresentationController!) -> UIModalPresentationStyle {
        return .None
    }
}

