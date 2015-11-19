//
//  ImageViewController.swift
//  ScrollableImage
//
//  Created by UnciaX on 2015/11/17.
//  Copyright © 2015年 UnciaX. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnUp: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnDown: UIButton!
    var ori_width:CGFloat=0
    var ori_height:CGFloat=0
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var imageURL:NSURL? {
        didSet {
            if view.window != nil {
                image = nil
                fetchImage()
            }
        }
    }
    
    private var imageView = UIImageView()
    
    private var image:UIImage? {
        get{ return imageView.image}
        set{
            spinner?.stopAnimating()
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView.contentSize=imageView.frame.size
            ori_width = imageView.frame.size.width
            ori_height = imageView.frame.size.height
            resetMinimumZoomScale()
            btnUp.enabled=false
            btnLeft.enabled=false
            btnRight.enabled=imageView.frame.size.width > scrollView.bounds.width ? true : false
            btnDown.enabled=imageView.frame.size.height > scrollView.bounds.height ? true : false
        }
    }
    
    private func fetchImage(){
        if let url = imageURL {
            spinner.startAnimating()
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()){
                    if url == self.imageURL{
                        if imageData != nil {
                            self.image = UIImage(data: imageData!)
                        }else{
                            self.image = nil
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func offSetButton(sender: AnyObject) {
        let btnName:String = sender.currentTitle!!
        var new_x,new_y:CGFloat
        switch(btnName){
            case "⬆︎":
                new_x = scrollView.contentOffset.x
                new_y = scrollView.contentOffset.y - scrollView.bounds.height
                if (new_y < 0) {
                    new_y = 0
                    btnUp.enabled = false
                    btnDown.enabled = true
                }else {
                    btnUp.enabled = true
                    btnDown.enabled = true
                }
                print("imageView.height:\(imageView.frame.size.height) x:\(new_x) y:\(new_y)")
                scrollView.contentOffset = CGPoint(x:new_x, y:new_y)
                break;
            case "➡︎":
                new_x = scrollView.contentOffset.x + scrollView.bounds.width
                new_y = scrollView.contentOffset.y
                if (new_x + scrollView.bounds.width > imageView.frame.size.width) {
                    new_x = imageView.frame.size.width - scrollView.bounds.width
                    btnRight.enabled = false
                    btnLeft.enabled = true
                } else {
                    btnRight.enabled = true
                    btnLeft.enabled = true
                }
                print("imageView.width:\(imageView.frame.size.width) x:\(new_x) y:\(new_y)")
                scrollView.contentOffset = CGPoint(x:new_x, y:new_y)
                break;
            case "⬇︎":
                new_x = scrollView.contentOffset.x
                new_y = scrollView.contentOffset.y + scrollView.bounds.height
                if (new_y + scrollView.bounds.height > scrollView.bounds.height) {
                    new_y = imageView.frame.size.height - scrollView.bounds.height
                    btnDown.enabled = false
                    btnUp.enabled=true
                } else {
                    btnDown.enabled = true
                    btnUp.enabled=true
                }
                print("imageView.height:\(imageView.frame.size.height) x:\(new_x) y:\(new_y)")
                scrollView.contentOffset = CGPoint(x:new_x, y:new_y)
                break;
            case "⬅︎":
                new_x = scrollView.contentOffset.x - scrollView.bounds.width
                new_y = scrollView.contentOffset.y
                if (new_x < 0) {
                    new_x = 0
                    btnLeft.enabled = false
                    btnRight.enabled=true
                } else {
                    btnLeft.enabled = true
                    btnRight.enabled=true
                }
                print("imageView.width:\(imageView.frame.size.width) x:\(new_x) y:\(new_y)")
                scrollView.contentOffset = CGPoint(x:new_x, y:new_y)                
                break;
            default: break;
        }
    }
    
    func resetMinimumZoomScale(){
        scrollView.minimumZoomScale = min(scrollView.bounds.size.height/ori_height , scrollView.bounds.size.width/ori_width)
        
        print("scrollView.height:\(scrollView.bounds.height) imageView.height:\(imageView.frame.size.height) ratio:\(scrollView.bounds.size.height/ori_height)")
        print("scrollView.width:\(scrollView.bounds.width) imageView.width:\(imageView.frame.size.width) ratio:\(scrollView.bounds.size.width/ori_width)")
        print("min:\(scrollView.minimumZoomScale)")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        btnUp.enabled = false
        btnLeft.enabled = false
        btnRight.enabled = false
        btnDown.enabled = false
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }


    func scrollViewDidZoom(scrollView: UIScrollView) {
        putImageAtCenter()
    }
    
//    func scrollViewDidEndZooming(_: UIScrollView,withView: UIView?, atScale: CGFloat){
//        let imageViewSize = imageView.frame.size
//        let scrollViewSize = scrollView.bounds.size
//        print("imageView: \(imageViewSize.height) x \(imageViewSize.width) . ScrollView: \(scrollViewSize.height) x \(scrollViewSize.width)")
//        if(scrollViewSize.width > imageViewSize.width || scrollViewSize.height > imageViewSize.height){
//            print("triggle")
//            let new_x = (imageViewSize.width-scrollViewSize.width)/2
//            let new_y = (imageViewSize.height-scrollViewSize.height)/2
//            scrollView.contentOffset = CGPoint(x: new_x, y: new_y)
//        }
//        print("Offset x: \(scrollView.contentOffset.x) . y:\(scrollView.contentOffset.y)")
//    }
    
    func putImageAtCenter(){
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        btnUp.enabled=imageView.frame.size.height > scrollView.bounds.height ? true : false
        btnLeft.enabled=imageView.frame.size.width > scrollView.bounds.width ? true : false
        btnRight.enabled=imageView.frame.size.width > scrollView.bounds.width ? true : false
        btnDown.enabled=imageView.frame.size.height > scrollView.bounds.height ? true : false
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        print("v:\(verticalPadding) h:\(horizontalPadding)")
        print("scrollView.height:\(scrollView.bounds.height) imageView.height:\(imageView.frame.size.height)")
        print("scrollView.width:\(scrollView.bounds.width) imageView.width:\(imageView.frame.size.width)")
    }
    
    
    override func viewWillLayoutSubviews() {
        if (imageURL != nil ) {
            let lastZoomScale = scrollView.zoomScale
            resetMinimumZoomScale()
            if (scrollView.zoomScale != 1.0) {
                print(scrollView.zoomScale)
                putImageAtCenter()
                if lastZoomScale < scrollView.minimumZoomScale { scrollView.zoomScale = scrollView.minimumZoomScale }
            }
        }
    }
    
}